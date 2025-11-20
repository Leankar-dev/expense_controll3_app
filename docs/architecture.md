# 🏗️ Arquitetura do Projeto - Expense Control APP

## Visão Geral

O **Expense Control APP** segue a arquitetura **MVVM (Model-View-ViewModel)** combinada com princípios de **Clean Architecture**, garantindo código escalável, testável e de fácil manutenção.

---

## 📐 Padrão MVVM (Model-View-ViewModel)

### Estrutura de Camadas

```
┌─────────────────────────────────────────┐
│           PRESENTATION LAYER            │
│  ┌─────────┐  ┌───────────┐  ┌───────┐ │
│  │  View   │→│ ViewModel │→│Provider│ │
│  └─────────┘  └───────────┘  └───────┘ │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│            DOMAIN LAYER                 │
│  ┌──────────┐         ┌────────────┐   │
│  │ Entities │         │  UseCases  │   │
│  └──────────┘         └────────────┘   │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│             DATA LAYER                  │
│  ┌────────┐  ┌────────────┐  ┌───────┐ │
│  │ Models │  │Repositories│  │  DAO  │ │
│  └────────┘  └────────────┘  └───────┘ │
└─────────────────────────────────────────┘
```

### **View (Apresentação)**
- Responsável pela UI e interação do usuário
- Construída com Widgets Flutter
- Observa o ViewModel e reage às mudanças de estado
- **NÃO** contém lógica de negócio

**Exemplo:**
```dart
class TransactionsListScreen extends ConsumerWidget {
  const TransactionsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsState = ref.watch(transactionViewModelProvider);
    
    return Scaffold(
      body: transactionsState.when(
        loading: () => const LoadingShimmer(),
        error: (error, _) => ErrorWidget(error.toString()),
        data: (transactions) => TransactionsList(transactions),
      ),
    );
  }
}
```

### **ViewModel (Lógica de Apresentação)**
- Gerencia o estado da UI
- Implementado com `AsyncNotifier` ou `Notifier` do Riverpod 3.x
- Chama UseCases da camada de domínio
- Formata dados para exibição
- **NÃO** conhece detalhes de implementação do repositório

**Exemplo com Riverpod 3.x:**
```dart
// Usando anotações (recomendado no Riverpod 3.x)
@riverpod
class TransactionViewModel extends _$TransactionViewModel {
  @override
  Future<List<Transaction>> build() async {
    return await _loadTransactions();
  }

  Future<List<Transaction>> _loadTransactions() async {
    final getTransactionsUseCase = ref.read(getTransactionsUseCaseProvider);
    final result = await getTransactionsUseCase.call();
    
    return result.fold(
      (failure) => throw failure,
      (transactions) => transactions,
    );
  }

  Future<void> createTransaction(Transaction transaction) async {
    state = const AsyncValue.loading();
    
    final createUseCase = ref.read(createTransactionUseCaseProvider);
    final result = await createUseCase.call(transaction);
    
    result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (newTransaction) async {
        // Recarrega a lista
        state = await AsyncValue.guard(() => _loadTransactions());
      },
    );
  }
}
```

**Forma Manual (sem anotações):**
```dart
class TransactionViewModel extends AsyncNotifier<List<Transaction>> {
  final GetTransactionsUseCase _getTransactionsUseCase;
  final CreateTransactionUseCase _createTransactionUseCase;
  
  TransactionViewModel(
    this._getTransactionsUseCase,
    this._createTransactionUseCase,
  );

  @override
  Future<List<Transaction>> build() async {
    final result = await _getTransactionsUseCase.call();
    
    return result.fold(
      (failure) => throw failure,
      (transactions) => transactions,
    );
  }

  Future<void> createTransaction(Transaction transaction) async {
    state = const AsyncValue.loading();
    
    final result = await _createTransactionUseCase.call(transaction);
    
    state = await AsyncValue.guard(() async {
      return result.fold(
        (failure) => throw failure,
        (_) => _getTransactionsUseCase.call().then(
          (r) => r.fold((f) => throw f, (t) => t),
        ),
      );
    });
  }
}
```

### **Model (Dados)**
- Representa os dados da aplicação
- Mapeia dados do banco de dados/API
- Inclui serialização/deserialização

---

## 🔄 Gerenciamento de Estado com Riverpod 3.x

### Por que Riverpod 3.x?

- ✅ **Code Generation:** Providers gerados automaticamente via anotações
- ✅ **Type-safe:** Detecção de erros em tempo de compilação
- ✅ **Testável:** Fácil de mockar e testar
- ✅ **Escalável:** Suporta aplicações complexas
- ✅ **Sem BuildContext:** Providers acessíveis em qualquer lugar
- ✅ **Performance:** Rebuild otimizado e automático
- ✅ **AsyncNotifier:** Novo modelo para estados assíncronos

### Tipos de Providers Utilizados (Riverpod 3.x)

#### **1. @riverpod - Provider Anotado (Recomendado)**
Usado para qualquer tipo de provider com geração automática.

```dart
// Provider simples
@riverpod
TransactionRepository transactionRepository(TransactionRepositoryRef ref) {
  final database = ref.watch(databaseProvider);
  final firebaseService = ref.watch(firebaseSyncServiceProvider);
  return TransactionRepositoryImpl(database, firebaseService);
}

// AsyncNotifier para estado assíncrono
@riverpod
class TransactionViewModel extends _$TransactionViewModel {
  @override
  Future<List<Transaction>> build() async {
    final repository = ref.watch(transactionRepositoryProvider);
    return await repository.getAllTransactions();
  }

  Future<void> addTransaction(Transaction transaction) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(transactionRepositoryProvider).create(transaction);
      return await ref.read(transactionRepositoryProvider).getAllTransactions();
    });
  }
}

// Uso na View
final transactionsAsync = ref.watch(transactionViewModelProvider);
```

#### **2. Provider Manual (quando necessário)**
Usado para dependências simples sem geração de código.

```dart
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return TransactionRepositoryImpl(database);
});
```

#### **3. FutureProvider**
Usado para operações assíncronas únicas.

```dart
@riverpod
Future<double> balance(BalanceRef ref) async {
  final calculateBalanceUseCase = ref.watch(calculateBalanceUseCaseProvider);
  return await calculateBalanceUseCase.call();
}

// Uso
final balanceAsync = ref.watch(balanceProvider);
balanceAsync.when(
  data: (balance) => Text('€${balance.toStringAsFixed(2)}'),
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Erro: $err'),
);
```

#### **4. StreamProvider**
Usado para dados que mudam ao longo do tempo.

```dart
@riverpod
Stream<List<Transaction>> transactionsStream(TransactionsStreamRef ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.watchAllTransactions();
}

// Uso
final transactionsStream = ref.watch(transactionsStreamProvider);
transactionsStream.when(
  data: (transactions) => ListView.builder(...),
  loading: () => LoadingShimmer(),
  error: (err, stack) => ErrorWidget(err),
);
```

#### **5. Notifier para Estado Síncrono**
```dart
@riverpod
class FilterNotifier extends _$FilterNotifier {
  @override
  TransactionFilter build() {
    return TransactionFilter.initial();
  }

  void updateCategory(String? category) {
    state = state.copyWith(category: category);
  }

  void updateDateRange(DateTimeRange? range) {
    state = state.copyWith(dateRange: range);
  }

  void reset() {
    state = TransactionFilter.initial();
  }
}
```

---

## 🎯 Clean Architecture - Camadas

### **1. Presentation Layer (Apresentação)**

**Responsabilidade:**  
Interface com o usuário e gerenciamento de estado da UI.

**Componentes:**
- `views/` - Telas e widgets
- `viewmodels/` - Lógica de apresentação
- `providers/` - Definição de providers Riverpod (principalmente usando anotações)

**Regras:**
- Depende apenas da camada de Domain
- NÃO conhece detalhes de implementação da camada Data

---

### **2. Domain Layer (Domínio)**

**Responsabilidade:**  
Lógica de negócio e regras da aplicação.

**Componentes:**
- `entities/` - Objetos de negócio
- `usecases/` - Casos de uso específicos

**Regras:**
- **Independente** de frameworks externos
- **Independente** da camada Data
- Contém apenas lógica de negócio pura

**Exemplo de UseCase:**
```dart
class CreateTransactionUseCase {
  final TransactionRepository _repository;
  
  CreateTransactionUseCase(this._repository);
  
  Future<Either<Failure, Transaction>> call(Transaction transaction) async {
    // Validações de negócio
    if (transaction.amount <= 0) {
      return Left(ValidationFailure('Valor deve ser maior que zero'));
    }
    
    // Delega ao repositório
    return await _repository.createTransaction(transaction);
  }
}

// Provider com Riverpod 3.x
@riverpod
CreateTransactionUseCase createTransactionUseCase(
  CreateTransactionUseCaseRef ref,
) {
  final repository = ref.watch(transactionRepositoryProvider);
  return CreateTransactionUseCase(repository);
}
```

---

### **3. Data Layer (Dados)**

**Responsabilidade:**  
Acesso a dados (local e remoto) e implementação de repositórios.

**Componentes:**
- `models/` - Modelos de dados
- `repositories/` - Implementação de repositórios
- `local/` - Acesso ao banco local (Drift)
- `remote/` - Acesso a APIs (Firebase)

**Regras:**
- Implementa interfaces definidas na camada Domain
- Lida com serialização/deserialização
- Gerencia cache e sincronização

**Exemplo de Repository:**
```dart
class TransactionRepositoryImpl implements TransactionRepository {
  final AppDatabase _database;
  final FirebaseSyncService _firebaseService;
  
  TransactionRepositoryImpl(this._database, this._firebaseService);
  
  @override
  Future<Either<Failure, Transaction>> createTransaction(
    Transaction transaction,
  ) async {
    try {
      // Salva local
      final id = await _database.transactionDao.insertTransaction(transaction);
      
      // Agenda sincronização
      await _firebaseService.scheduleSync(id);
      
      return Right(transaction.copyWith(id: id));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}

// Provider com Riverpod 3.x
@riverpod
TransactionRepository transactionRepository(TransactionRepositoryRef ref) {
  final database = ref.watch(databaseProvider);
  final firebaseService = ref.watch(firebaseSyncServiceProvider);
  return TransactionRepositoryImpl(database, firebaseService);
}
```

---

## 🔗 Injeção de Dependências com Riverpod 3.x

### Estratégia com Anotações

Todas as dependências são injetadas via Providers Riverpod usando **anotações**, seguindo o **Dependency Inversion Principle**.

**Exemplo de Cadeia de Dependências:**

```dart
// 1. Database Provider (底層)
@riverpod
AppDatabase database(DatabaseRef ref) {
  return AppDatabase();
}

// 2. Firebase Service Provider
@riverpod
FirebaseSyncService firebaseSyncService(FirebaseSyncServiceRef ref) {
  final firestore = FirebaseFirestore.instance;
  final database = ref.watch(databaseProvider);
  return FirebaseSyncService(firestore, database);
}

// 3. Repository Provider
@riverpod
TransactionRepository transactionRepository(TransactionRepositoryRef ref) {
  final database = ref.watch(databaseProvider);
  final firebaseService = ref.watch(firebaseSyncServiceProvider);
  return TransactionRepositoryImpl(database, firebaseService);
}

// 4. UseCase Provider
@riverpod
CreateTransactionUseCase createTransactionUseCase(
  CreateTransactionUseCaseRef ref,
) {
  final repository = ref.watch(transactionRepositoryProvider);
  return CreateTransactionUseCase(repository);
}

@riverpod
GetTransactionsUseCase getTransactionsUseCase(GetTransactionsUseCaseRef ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return GetTransactionsUseCase(repository);
}

// 5. ViewModel Provider (最上層)
@riverpod
class TransactionViewModel extends _$TransactionViewModel {
  @override
  Future<List<Transaction>> build() async {
    final getUseCase = ref.watch(getTransactionsUseCaseProvider);
    final result = await getUseCase.call();
    return result.fold(
      (failure) => throw failure,
      (transactions) => transactions,
    );
  }

  Future<void> createTransaction(Transaction transaction) async {
    state = const AsyncValue.loading();
    
    final createUseCase = ref.read(createTransactionUseCaseProvider);
    final result = await createUseCase.call(transaction);
    
    state = await AsyncValue.guard(() async {
      return result.fold(
        (failure) => throw failure,
        (_) async {
          final getUseCase = ref.read(getTransactionsUseCaseProvider);
          final getResult = await getUseCase.call();
          return getResult.fold(
            (f) => throw f,
            (transactions) => transactions,
          );
        },
      );
    });
  }
}
```

---

## 🧪 Testabilidade

### Benefícios da Arquitetura para Testes

#### **1. ViewModels Isolados (Riverpod 3.x)**
```dart
void main() {
  test('should load transactions successfully', () async {
    // Arrange
    final container = ProviderContainer(
      overrides: [
        getTransactionsUseCaseProvider.overrideWithValue(
          MockGetTransactionsUseCase(),
        ),
      ],
    );
    
    when(container.read(getTransactionsUseCaseProvider).call())
        .thenAnswer((_) async => Right([mockTransaction]));
    
    // Act
    final viewModel = container.read(transactionViewModelProvider.notifier);
    await container.read(transactionViewModelProvider.future);
    
    // Assert
    final state = container.read(transactionViewModelProvider);
    expect(state.hasValue, true);
    expect(state.value, [mockTransaction]);
  });
}
```

#### **2. UseCases Independentes**
```dart
test('should return validation failure when amount is zero', () async {
  // Arrange
  final mockRepository = MockTransactionRepository();
  final useCase = CreateTransactionUseCase(mockRepository);
  
  // Act
  final result = await useCase.call(transactionWithZeroAmount);
  
  // Assert
  expect(result.isLeft(), true);
  verifyNever(mockRepository.createTransaction(any));
});
```

#### **3. Repositories Mockáveis**
```dart
test('should save transaction to database', () async {
  // Arrange
  final mockDao = MockTransactionDao();
  final mockFirebase = MockFirebaseSyncService();
  final repository = TransactionRepositoryImpl(mockDao, mockFirebase);
  
  // Act
  await repository.createTransaction(mockTransaction);
  
  // Assert
  verify(mockDao.insertTransaction(mockTransaction)).called(1);
});
```

---

## 📋 Boas Práticas Implementadas

### ✅ **1. Single Responsibility Principle (SRP)**
Cada classe tem uma única responsabilidade.

### ✅ **2. Dependency Inversion Principle (DIP)**
Dependências apontam para abstrações, não implementações.

### ✅ **3. Interface Segregation**
Interfaces pequenas e focadas.

### ✅ **4. Separation of Concerns**
Camadas bem definidas com responsabilidades claras.

### ✅ **5. Imutabilidade**
Estados imutáveis usando `copyWith()`.

### ✅ **6. Error Handling**
Uso de `Either<Failure, Success>` para tratamento de erros.

### ✅ **7. Async/Await**
Operações assíncronas bem gerenciadas com AsyncNotifier.

### ✅ **8. Code Generation**
Uso de anotações Riverpod 3.x para providers automáticos.

### ✅ **9. Code Documentation**
Comentários inline e documentação de APIs públicas.

---

## 🎓 Referências e Recursos

- [Riverpod 3.x Documentation](https://riverpod.dev/)
- [Riverpod Code Generation](https://riverpod.dev/docs/concepts/about_code_generation)
- [Flutter MVVM Architecture](https://medium.com/flutter-community/mvvm-in-flutter-edd212fd6695)
- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Best Practices](https://flutter.dev/docs/development/best-practices)

---

**Desenvolvido por:** Leankar.dev  
**Versão:** 1.0.0  
**Stack:** Flutter 3.38+ | Dart 3.10+ | Riverpod 3.0.3  
**Contato:** leankar.dev@gmail.com