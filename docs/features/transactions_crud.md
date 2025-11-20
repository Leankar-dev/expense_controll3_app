# 💰 Feature: CRUD de Transações - Expense Control APP

## Objetivo

Implementar sistema completo de gerenciamento de transações financeiras (receitas e despesas) com filtros avançados, busca e ordenação.

---

## Requisitos Funcionais

### RF01 - Criar Transação
- ✅ Formulário com todos os campos obrigatórios
- ✅ Validação de valores (amount > 0)
- ✅ Seleção de categoria
- ✅ Seleção de data via calendário
- ✅ Escolha de método de pagamento
- ✅ Definição de tipo (Income/Expense)
- ✅ Geração automática de UUID

### RF02 - Editar Transação
- ✅ Pré-preenchimento dos campos
- ✅ Mesmas validações da criação
- ✅ Atualização do timestamp `updatedAt`

### RF03 - Deletar Transação
- ✅ Confirmação antes da exclusão
- ✅ Soft-delete (marcação `isDeleted`)
- ✅ Feedback visual de sucesso

### RF04 - Listar Transações
- ✅ Ordenação por data (mais recente primeiro)
- ✅ Visualização em cards
- ✅ Loading shimmer
- ✅ Pull-to-refresh

### RF05 - Filtros Avançados
- ✅ Por categoria
- ✅ Por período (dia/semana/mês/ano)
- ✅ Por tipo (receita/despesa)
- ✅ Combinação de filtros

### RF06 - Busca
- ✅ Por descrição
- ✅ Por categoria
- ✅ Por valor

### RF07 - Ordenação
- ✅ Por data (crescente/decrescente)
- ✅ Por valor (maior/menor)
- ✅ Por categoria (alfabética)

---

## Campos da Transação

```dart
class Transaction {
  final String id;                  // UUID gerado automaticamente
  final double amount;              // Valor > 0
  final String category;            // Categoria selecionada
  final String description;         // Descrição detalhada
  final DateTime date;              // Data da transação
  final PaymentMethod paymentMethod; // Enum
  final TransactionType type;       // Enum (Income/Expense)
  final String userId;              // ID do usuário
  final DateTime createdAt;         // Timestamp de criação
  final DateTime updatedAt;         // Timestamp de atualização
  final bool isDeleted;             // Soft-delete flag
  final DateTime? syncedAt;         // Última sincronização
}
```

---

## Enums

### PaymentMethod
```dart
enum PaymentMethod {
  creditCard('Cartão de Crédito'),
  debitCard('Cartão de Débito'),
  mbWay('MBWay'),
  pix('PIX'),
  cash('Dinheiro');

  final String displayName;
  const PaymentMethod(this.displayName);
}
```

### TransactionType
```dart
enum TransactionType {
  income('Receita'),
  expense('Despesa');

  final String displayName;
  const TransactionType(this.displayName);
}
```

---

## Validações

### Valor (Amount)
```dart
String? validateAmount(String? value) {
  if (value == null || value.isEmpty) {
    return 'Valor é obrigatório';
  }
  
  final amount = double.tryParse(value.replaceAll(',', '.'));
  if (amount == null) {
    return 'Valor inválido';
  }
  
  if (amount <= 0) {
    return 'Valor deve ser maior que zero';
  }
  
  return null;
}
```

### Descrição
```dart
String? validateDescription(String? value) {
  if (value == null || value.isEmpty) {
    return 'Descrição é obrigatória';
  }
  
  if (value.length < 3) {
    return 'Descrição deve ter no mínimo 3 caracteres';
  }
  
  return null;
}
```

---

## Arquitetura MVVM

### 1. ViewModel

```dart
class TransactionState {
  final List<Transaction> transactions;
  final bool isLoading;
  final String? errorMessage;
  final TransactionFilter? currentFilter;
  final TransactionSort currentSort;

  TransactionState({
    this.transactions = const [],
    this.isLoading = false,
    this.errorMessage,
    this.currentFilter,
    this.currentSort = TransactionSort.dateDesc,
  });
}

class TransactionViewModel extends StateNotifier<TransactionState> {
  final CreateTransactionUseCase _createUseCase;
  final UpdateTransactionUseCase _updateUseCase;
  final DeleteTransactionUseCase _deleteUseCase;
  final GetTransactionsUseCase _getUseCase;
  final FilterTransactionsUseCase _filterUseCase;

  TransactionViewModel(...) : super(TransactionState());

  Future<void> createTransaction(Transaction transaction) async {
    state = state.copyWith(isLoading: true);

    final result = await _createUseCase.call(transaction);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (transaction) {
        state = state.copyWith(
          isLoading: false,
          transactions: [...state.transactions, transaction],
        );
      },
    );
  }

  Future<void> loadTransactions() async {
    state = state.copyWith(isLoading: true);

    final result = await _getUseCase.call();

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (transactions) => state = state.copyWith(
        isLoading: false,
        transactions: transactions,
      ),
    );
  }

  void applyFilter(TransactionFilter filter) {
    state = state.copyWith(currentFilter: filter);
    _filterAndSort();
  }

  void applySort(TransactionSort sort) {
    state = state.copyWith(currentSort: sort);
    _filterAndSort();
  }

  void search(String query) {
    final filtered = state.transactions.where((t) {
      return t.description.toLowerCase().contains(query.toLowerCase()) ||
             t.category.toLowerCase().contains(query.toLowerCase()) ||
             t.amount.toString().contains(query);
    }).toList();

    state = state.copyWith(transactions: filtered);
  }

  void _filterAndSort() {
    var filtered = state.transactions;

    // Aplicar filtros
    if (state.currentFilter != null) {
      filtered = _filterUseCase.call(filtered, state.currentFilter!);
    }

    // Aplicar ordenação
    filtered = _sortTransactions(filtered, state.currentSort);

    state = state.copyWith(transactions: filtered);
  }

  List<Transaction> _sortTransactions(
    List<Transaction> transactions,
    TransactionSort sort,
  ) {
    switch (sort) {
      case TransactionSort.dateDesc:
        return transactions..sort((a, b) => b.date.compareTo(a.date));
      case TransactionSort.dateAsc:
        return transactions..sort((a, b) => a.date.compareTo(b.date));
      case TransactionSort.amountDesc:
        return transactions..sort((a, b) => b.amount.compareTo(a.amount));
      case TransactionSort.amountAsc:
        return transactions..sort((a, b) => a.amount.compareTo(b.amount));
      case TransactionSort.categoryAsc:
        return transactions..sort((a, b) => a.category.compareTo(b.category));
    }
  }
}
```

---

### 2. View - Transaction Form

```dart
class TransactionFormScreen extends ConsumerStatefulWidget {
  final Transaction? transaction; // null = create, not null = edit

  const TransactionFormScreen({Key? key, this.transaction}) : super(key: key);

  @override
  ConsumerState<TransactionFormScreen> createState() =>
      _TransactionFormScreenState();
}

class _TransactionFormScreenState
    extends ConsumerState<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  
  String? selectedCategory;
  DateTime selectedDate = DateTime.now();
  PaymentMethod selectedPaymentMethod = PaymentMethod.cash;
  TransactionType selectedType = TransactionType.expense;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.transaction?.amount.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.transaction?.description ?? '',
    );
    
    if (widget.transaction != null) {
      selectedCategory = widget.transaction!.category;
      selectedDate = widget.transaction!.date;
      selectedPaymentMethod = widget.transaction!.paymentMethod;
      selectedType = widget.transaction!.type;
    }
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      final transaction = Transaction(
        id: widget.transaction?.id ?? const Uuid().v4(),
        amount: double.parse(_amountController.text.replaceAll(',', '.')),
        category: selectedCategory!,
        description: _descriptionController.text,
        date: selectedDate,
        paymentMethod: selectedPaymentMethod,
        type: selectedType,
        userId: ref.read(authViewModelProvider).user!.id,
        createdAt: widget.transaction?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        isDeleted: false,
        syncedAt: null,
      );

      if (widget.transaction == null) {
        await ref.read(transactionViewModelProvider.notifier)
            .createTransaction(transaction);
        CustomSnackBar.showSuccess(context, 'Transação criada com sucesso!');
      } else {
        await ref.read(transactionViewModelProvider.notifier)
            .updateTransaction(transaction);
        CustomSnackBar.showSuccess(context, 'Transação atualizada com sucesso!');
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryViewModelProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.transaction == null
            ? 'Nova Transação'
            : 'Editar Transação',
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Tipo (Receita/Despesa)
            NeumorphicSegmentedControl(
              value: selectedType,
              options: TransactionType.values,
              onChanged: (value) => setState(() => selectedType = value),
            ),
            const SizedBox(height: 24),

            // Valor
            NeumorphicTextFormField(
              controller: _amountController,
              labelText: 'Valor (€)',
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: Validators.validateAmount,
            ),
            const SizedBox(height: 16),

            // Categoria
            NeumorphicDropdown<String>(
              labelText: 'Categoria',
              value: selectedCategory,
              items: categories.map((c) => c.name).toList(),
              onChanged: (value) => setState(() => selectedCategory = value),
              validator: (value) => value == null ? 'Selecione uma categoria' : null,
            ),
            const SizedBox(height: 16),

            // Descrição
            NeumorphicTextFormField(
              controller: _descriptionController,
              labelText: 'Descrição',
              maxLines: 3,
              validator: Validators.validateDescription,
            ),
            const SizedBox(height: 16),

            // Data
            NeumorphicDatePicker(
              labelText: 'Data',
              selectedDate: selectedDate,
              onDateChanged: (date) => setState(() => selectedDate = date),
            ),
            const SizedBox(height: 16),

            // Método de Pagamento
            NeumorphicDropdown<PaymentMethod>(
              labelText: 'Método de Pagamento',
              value: selectedPaymentMethod,
              items: PaymentMethod.values,
              itemBuilder: (method) => method.displayName,
              onChanged: (value) => setState(() => selectedPaymentMethod = value!),
            ),
            const SizedBox(height: 32),

            // Botão Salvar
            CustomNeumorphicButton(
              text: 'Guardar',
              onPressed: _handleSave,
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### 3. View - Transactions List

```dart
class TransactionsListScreen extends ConsumerWidget {
  const TransactionsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionState = ref.watch(transactionViewModelProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Transações',
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context, ref),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _showSearchDialog(context, ref),
          ),
        ],
      ),
      body: transactionState.isLoading
          ? const LoadingShimmer()
          : RefreshIndicator(
              onRefresh: () async {
                await ref.read(transactionViewModelProvider.notifier)
                    .loadTransactions();
              },
              child: transactionState.transactions.isEmpty
                  ? const EmptyStateWidget(
                      message: 'Nenhuma transação encontrada',
                    )
                  : ListView.builder(
                      itemCount: transactionState.transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactionState.transactions[index];
                        return ExpenseCard(
                          transaction: transaction,
                          onTap: () => _navigateToEdit(context, transaction),
                          onDelete: () => _handleDelete(context, ref, transaction),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(
          AppRoutes.transactionForm,
        ),
        child: Icon(Icons.add),
      ),
    );
  }

  void _handleDelete(
    BuildContext context,
    WidgetRef ref,
    Transaction transaction,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir esta transação?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(transactionViewModelProvider.notifier)
          .deleteTransaction(transaction.id);
      CustomSnackBar.showSuccess(context, 'Transação excluída com sucesso!');
    }
  }
}
```

---

## Testes

```dart
void main() {
  group('TransactionViewModel', () {
    test('should create transaction successfully', () async {
      // Arrange
      final mockUseCase = MockCreateTransactionUseCase();
      when(mockUseCase.call(any)).thenAnswer((_) async => Right(mockTransaction));
      final viewModel = TransactionViewModel(mockUseCase, ...);

      // Act
      await viewModel.createTransaction(mockTransaction);

      // Assert
      expect(viewModel.state.transactions, contains(mockTransaction));
      verify(mockUseCase.call(mockTransaction)).called(1);
    });

    test('should filter transactions by category', () {
      // Arrange & Act
      viewModel.applyFilter(TransactionFilter(category: 'Alimentação'));

      // Assert
      expect(
        viewModel.state.transactions.every((t) => t.category == 'Alimentação'),
        true,
      );
    });

    test('should sort transactions by amount descending', () {
      // Act
      viewModel.applySort(TransactionSort.amountDesc);

      // Assert
      final amounts = viewModel.state.transactions.map((t) => t.amount).toList();
      expect(amounts, orderedBy((a, b) => b.compareTo(a)));
    });
  });
}
```

---

**Desenvolvido por:** Leankar.dev