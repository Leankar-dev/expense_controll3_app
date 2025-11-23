import 'package:drift/drift.dart';

import '../enums/payment_method.dart';
import '../enums/transaction_type.dart';
import '../local/dao/transaction_dao.dart';
import '../local/database/app_database.dart';
import '../models/transaction_model.dart';
import '../../core/exceptions/repository_exception.dart';

class TransactionRepository {
  final TransactionDao _transactionDao;

  TransactionRepository(this._transactionDao);

  Future<String> createTransaction(TransactionModel transaction) async {
    try {
      final companion = _toCompanion(transaction);
      await _transactionDao.insertTransaction(companion);
      return transaction.id;
    } catch (e) {
      throw RepositoryException(
        'Erro ao criar transação: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      final data = await _transactionDao.getTransactionById(transaction.id);
      if (data == null) {
        throw RepositoryException('Transação não encontrada');
      }

      final updatedData = _toTransactionData(transaction);
      final success = await _transactionDao.updateTransaction(updatedData);

      if (!success) {
        throw RepositoryException('Falha ao atualizar transação');
      }
    } catch (e) {
      if (e is RepositoryException) rethrow;
      throw RepositoryException(
        'Erro ao atualizar transação: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      final count = await _transactionDao.deleteTransaction(id);
      if (count == 0) {
        throw RepositoryException('Transação não encontrada');
      }
    } catch (e) {
      if (e is RepositoryException) rethrow;
      throw RepositoryException(
        'Erro ao deletar transação: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<void> softDeleteTransaction(String id) async {
    try {
      final count = await _transactionDao.softDeleteTransaction(id);
      if (count == 0) {
        throw RepositoryException('Transação não encontrada');
      }
    } catch (e) {
      if (e is RepositoryException) rethrow;
      throw RepositoryException(
        'Erro ao marcar transação como deletada: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<void> restoreTransaction(String id) async {
    try {
      final count = await _transactionDao.restoreTransaction(id);
      if (count == 0) {
        throw RepositoryException('Transação não encontrada');
      }
    } catch (e) {
      if (e is RepositoryException) rethrow;
      throw RepositoryException(
        'Erro ao restaurar transação: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<TransactionModel?> getTransactionById(String id) async {
    try {
      final data = await _transactionDao.getTransactionById(id);
      return data != null ? _toModel(data) : null;
    } catch (e) {
      throw RepositoryException(
        'Erro ao buscar transação: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      final dataList = await _transactionDao.getAllTransactions();
      return dataList.map(_toModel).toList();
    } catch (e) {
      throw RepositoryException(
        'Erro ao buscar todas as transações: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Stream<List<TransactionModel>> watchAllTransactions() {
    try {
      return _transactionDao.watchAllTransactions().map(
        (dataList) => dataList.map(_toModel).toList(),
      );
    } catch (e) {
      throw RepositoryException(
        'Erro ao observar transações: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<List<TransactionModel>> getActiveTransactions() async {
    try {
      final dataList = await _transactionDao.getActiveTransactions();
      return dataList.map(_toModel).toList();
    } catch (e) {
      throw RepositoryException(
        'Erro ao buscar transações ativas: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<List<TransactionModel>> getTransactionsByUser(String userId) async {
    try {
      final dataList = await _transactionDao.getTransactionsByUser(userId);
      return dataList.map(_toModel).toList();
    } catch (e) {
      throw RepositoryException(
        'Erro ao buscar transações do usuário: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Stream<List<TransactionModel>> watchTransactionsByUser(String userId) {
    try {
      return _transactionDao
          .watchTransactionsByUser(userId)
          .map(
            (dataList) => dataList.map(_toModel).toList(),
          );
    } catch (e) {
      throw RepositoryException(
        'Erro ao observar transações do usuário: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<List<TransactionModel>> getTransactionsByType(
    TransactionType type, {
    String? userId,
  }) async {
    try {
      final dataList = await _transactionDao.getTransactionsByType(
        type,
        userId: userId,
      );
      return dataList.map(_toModel).toList();
    } catch (e) {
      throw RepositoryException(
        'Erro ao buscar transações por tipo: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Stream<List<TransactionModel>> watchTransactionsByType(
    TransactionType type, {
    String? userId,
  }) {
    try {
      return _transactionDao
          .watchTransactionsByType(type, userId: userId)
          .map((dataList) => dataList.map(_toModel).toList());
    } catch (e) {
      throw RepositoryException(
        'Erro ao observar transações por tipo: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<List<TransactionModel>> getTransactionsByCategory(
    String category, {
    String? userId,
  }) async {
    try {
      final dataList = await _transactionDao.getTransactionsByCategory(
        category,
        userId: userId,
      );
      return dataList.map(_toModel).toList();
    } catch (e) {
      throw RepositoryException(
        'Erro ao buscar transações por categoria: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Stream<List<TransactionModel>> watchTransactionsByCategory(
    String category, {
    String? userId,
  }) {
    try {
      return _transactionDao
          .watchTransactionsByCategory(category, userId: userId)
          .map((dataList) => dataList.map(_toModel).toList());
    } catch (e) {
      throw RepositoryException(
        'Erro ao observar transações por categoria: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<List<TransactionModel>> getTransactionsByPaymentMethod(
    PaymentMethod method, {
    String? userId,
  }) async {
    try {
      final dataList = await _transactionDao.getTransactionsByPaymentMethod(
        method,
        userId: userId,
      );
      return dataList.map(_toModel).toList();
    } catch (e) {
      throw RepositoryException(
        'Erro ao buscar transações por método de pagamento: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<List<TransactionModel>> getTransactionsByPeriod(
    DateTime startDate,
    DateTime endDate, {
    String? userId,
  }) async {
    try {
      final dataList = await _transactionDao.getTransactionsByPeriod(
        startDate,
        endDate,
        userId: userId,
      );
      return dataList.map(_toModel).toList();
    } catch (e) {
      throw RepositoryException(
        'Erro ao buscar transações por período: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Stream<List<TransactionModel>> watchTransactionsByPeriod(
    DateTime startDate,
    DateTime endDate, {
    String? userId,
  }) {
    try {
      return _transactionDao
          .watchTransactionsByPeriod(startDate, endDate, userId: userId)
          .map((dataList) => dataList.map(_toModel).toList());
    } catch (e) {
      throw RepositoryException(
        'Erro ao observar transações por período: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<List<TransactionModel>> searchTransactions(
    String query, {
    String? userId,
  }) async {
    try {
      final dataList = await _transactionDao.searchTransactions(
        query,
        userId: userId,
      );
      return dataList.map(_toModel).toList();
    } catch (e) {
      throw RepositoryException(
        'Erro ao buscar transações: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<double> calculateTotalBalance({String? userId}) async {
    try {
      return await _transactionDao.calculateTotalBalance(userId: userId);
    } catch (e) {
      throw RepositoryException(
        'Erro ao calcular saldo total: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<double> calculateTotalIncome({String? userId}) async {
    try {
      return await _transactionDao.calculateTotalIncome(userId: userId);
    } catch (e) {
      throw RepositoryException(
        'Erro ao calcular receitas totais: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<double> calculateTotalExpenses({String? userId}) async {
    try {
      return await _transactionDao.calculateTotalExpenses(userId: userId);
    } catch (e) {
      throw RepositoryException(
        'Erro ao calcular despesas totais: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<double> calculateBalanceByPeriod(
    DateTime startDate,
    DateTime endDate, {
    String? userId,
  }) async {
    try {
      return await _transactionDao.calculateBalanceByPeriod(
        startDate,
        endDate,
        userId: userId,
      );
    } catch (e) {
      throw RepositoryException(
        'Erro ao calcular saldo por período: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<double> calculateTotalByCategory(
    String category, {
    String? userId,
  }) async {
    try {
      return await _transactionDao.calculateTotalByCategory(
        category,
        userId: userId,
      );
    } catch (e) {
      throw RepositoryException(
        'Erro ao calcular total por categoria: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<Map<String, double>> getCategoryDistribution({
    String? userId,
    TransactionType? type,
  }) async {
    try {
      return await _transactionDao.getCategoryDistribution(
        userId: userId,
        type: type,
      );
    } catch (e) {
      throw RepositoryException(
        'Erro ao obter distribuição por categoria: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<int> countTransactions({String? userId}) async {
    try {
      return await _transactionDao.countTransactions(userId: userId);
    } catch (e) {
      throw RepositoryException(
        'Erro ao contar transações: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<List<TransactionModel>> getPendingSync({String? userId}) async {
    try {
      final dataList = await _transactionDao.getPendingSync(userId: userId);
      return dataList.map(_toModel).toList();
    } catch (e) {
      throw RepositoryException(
        'Erro ao buscar transações pendentes de sincronização: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<void> markAsSynced(String id) async {
    try {
      final count = await _transactionDao.markAsSynced(id);
      if (count == 0) {
        throw RepositoryException('Transação não encontrada');
      }
    } catch (e) {
      if (e is RepositoryException) rethrow;
      throw RepositoryException(
        'Erro ao marcar transação como sincronizada: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<void> updateSyncedAt(String id, DateTime syncedAt) async {
    try {
      final count = await _transactionDao.updateSyncedAt(id, syncedAt);
      if (count == 0) {
        throw RepositoryException('Transação não encontrada');
      }
    } catch (e) {
      if (e is RepositoryException) rethrow;
      throw RepositoryException(
        'Erro ao atualizar timestamp de sincronização: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<void> insertMultiple(List<TransactionModel> transactions) async {
    try {
      final companions = transactions.map(_toCompanion).toList();
      await _transactionDao.insertMultiple(companions);
    } catch (e) {
      throw RepositoryException(
        'Erro ao inserir múltiplas transações: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<int> deleteOldTransactions(DateTime beforeDate) async {
    try {
      return await _transactionDao.deleteOldTransactions(beforeDate);
    } catch (e) {
      throw RepositoryException(
        'Erro ao deletar transações antigas: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<int> deleteAllByUser(String userId) async {
    try {
      return await _transactionDao.deleteAllByUser(userId);
    } catch (e) {
      throw RepositoryException(
        'Erro ao deletar todas as transações do usuário: ${e.toString()}',
        originalError: e,
      );
    }
  }

  TransactionsCompanion _toCompanion(TransactionModel model) {
    return TransactionsCompanion.insert(
      id: model.id,
      amount: model.amount,
      category: model.category,
      description: model.description,
      date: model.date,
      paymentMethod: model.paymentMethod,
      type: model.type,
      userId: model.userId,
      createdAt: Value(model.createdAt),
      updatedAt: Value(model.updatedAt),
      isDeleted: Value(model.isDeleted),
      syncedAt: Value(model.syncedAt),
    );
  }

  TransactionData _toTransactionData(TransactionModel model) {
    return TransactionData(
      id: model.id,
      amount: model.amount,
      category: model.category,
      description: model.description,
      date: model.date,
      paymentMethod: model.paymentMethod,
      type: model.type,
      userId: model.userId,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      isDeleted: model.isDeleted,
      syncedAt: model.syncedAt,
    );
  }

  TransactionModel _toModel(TransactionData data) {
    return TransactionModel(
      id: data.id,
      amount: data.amount,
      category: data.category,
      description: data.description,
      date: data.date,
      paymentMethod: data.paymentMethod,
      type: data.type,
      userId: data.userId,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      isDeleted: data.isDeleted,
      syncedAt: data.syncedAt,
    );
  }
}
