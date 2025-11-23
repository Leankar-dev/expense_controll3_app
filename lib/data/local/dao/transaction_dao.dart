import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/tables/transactions_table.dart';
import '../../enums/transaction_type.dart';
import '../../enums/payment_method.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [Transactions])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(super.db);

  Future<int> insertTransaction(TransactionsCompanion transaction) async {
    try {
      if (transaction.amount.present && transaction.amount.value <= 0) {
        throw ArgumentError('Valor da transação deve ser maior que zero');
      }

      if (transaction.description.present &&
          transaction.description.value.trim().isEmpty) {
        throw ArgumentError('Descrição não pode ser vazia');
      }

      return await into(transactions).insert(transaction);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateTransaction(TransactionData transaction) async {
    try {
      if (transaction.amount <= 0) {
        throw ArgumentError('Valor da transação deve ser maior que zero');
      }

      if (transaction.description.trim().isEmpty) {
        throw ArgumentError('Descrição não pode ser vazia');
      }

      if (transaction.id.trim().isEmpty) {
        throw ArgumentError('ID da transação não pode ser vazio');
      }

      final updatedTransaction = transaction.copyWith(
        updatedAt: DateTime.now(),
      );

      return await update(transactions).replace(updatedTransaction);
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteTransaction(String id) {
    return (delete(transactions)..where((t) => t.id.equals(id))).go();
  }

  Future<int> softDeleteTransaction(String id) {
    return (update(transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> restoreTransaction(String id) {
    return (update(transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        isDeleted: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<TransactionData?> getTransactionById(String id) {
    return (select(
      transactions,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<TransactionData>> getAllTransactions() {
    return select(transactions).get();
  }

  Stream<List<TransactionData>> watchAllTransactions() {
    return (select(transactions)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  Future<List<TransactionData>> getActiveTransactions() {
    return (select(transactions)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  Future<List<TransactionData>> getTransactionsByUser(String userId) {
    return (select(transactions)
          ..where((t) => t.userId.equals(userId))
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  Stream<List<TransactionData>> watchTransactionsByUser(String userId) {
    return (select(transactions)
          ..where((t) => t.userId.equals(userId))
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  Future<List<TransactionData>> getTransactionsByType(
    TransactionType type, {
    String? userId,
  }) {
    final query = select(transactions)
      ..where((t) => t.type.equalsValue(type))
      ..where((t) => t.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);

    if (userId != null) {
      query.where((t) => t.userId.equals(userId));
    }

    return query.get();
  }

  Stream<List<TransactionData>> watchTransactionsByType(
    TransactionType type, {
    String? userId,
  }) {
    final query = select(transactions)
      ..where((t) => t.type.equalsValue(type))
      ..where((t) => t.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);

    if (userId != null) {
      query.where((t) => t.userId.equals(userId));
    }

    return query.watch();
  }

  Future<List<TransactionData>> getTransactionsByCategory(
    String category, {
    String? userId,
  }) {
    if (category.trim().isEmpty) {
      throw ArgumentError('Categoria não pode ser vazia');
    }

    final query = select(transactions)
      ..where((t) => t.category.equals(category))
      ..where((t) => t.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);

    if (userId != null) {
      query.where((t) => t.userId.equals(userId));
    }

    return query.get();
  }

  Stream<List<TransactionData>> watchTransactionsByCategory(
    String category, {
    String? userId,
  }) {
    if (category.trim().isEmpty) {
      throw ArgumentError('Categoria não pode ser vazia');
    }

    final query = select(transactions)
      ..where((t) => t.category.equals(category))
      ..where((t) => t.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);

    if (userId != null) {
      query.where((t) => t.userId.equals(userId));
    }

    return query.watch();
  }

  Future<List<TransactionData>> getTransactionsByPaymentMethod(
    PaymentMethod method, {
    String? userId,
  }) {
    final query = select(transactions)
      ..where((t) => t.paymentMethod.equalsValue(method))
      ..where((t) => t.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);

    if (userId != null) {
      query.where((t) => t.userId.equals(userId));
    }

    return query.get();
  }

  Future<List<TransactionData>> getTransactionsByPeriod(
    DateTime startDate,
    DateTime endDate, {
    String? userId,
  }) {
    if (startDate.isAfter(endDate)) {
      throw ArgumentError('Data inicial não pode ser posterior à data final');
    }

    final maxFutureDate = DateTime.now().add(const Duration(days: 365));
    if (endDate.isAfter(maxFutureDate)) {
      throw ArgumentError('Data final muito distante no futuro');
    }

    final query = select(transactions)
      ..where((t) => t.date.isBiggerOrEqualValue(startDate))
      ..where((t) => t.date.isSmallerOrEqualValue(endDate))
      ..where((t) => t.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);

    if (userId != null) {
      query.where((t) => t.userId.equals(userId));
    }

    return query.get();
  }

  Stream<List<TransactionData>> watchTransactionsByPeriod(
    DateTime startDate,
    DateTime endDate, {
    String? userId,
  }) {
    if (startDate.isAfter(endDate)) {
      throw ArgumentError('Data inicial não pode ser posterior à data final');
    }

    final query = select(transactions)
      ..where((t) => t.date.isBiggerOrEqualValue(startDate))
      ..where((t) => t.date.isSmallerOrEqualValue(endDate))
      ..where((t) => t.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);

    if (userId != null) {
      query.where((t) => t.userId.equals(userId));
    }

    return query.watch();
  }

  Future<List<TransactionData>> searchTransactions(
    String query, {
    String? userId,
  }) {
    if (query.trim().isEmpty) {
      throw ArgumentError('Query de busca não pode ser vazia');
    }

    if (query.length > 100) {
      throw ArgumentError('Query muito longa (max 100 caracteres)');
    }

    final searchQuery = select(transactions)
      ..where((t) => t.description.contains(query.trim()))
      ..where((t) => t.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);

    if (userId != null) {
      searchQuery.where((t) => t.userId.equals(userId));
    }

    return searchQuery.get();
  }

  Future<double> calculateTotalBalance({String? userId}) async {
    final income = await _calculateTotalByType(
      TransactionType.income,
      userId: userId,
    );
    final expense = await _calculateTotalByType(
      TransactionType.expense,
      userId: userId,
    );
    return income - expense;
  }

  Future<double> _calculateTotalByType(
    TransactionType type, {
    String? userId,
  }) async {
    final query = selectOnly(transactions)
      ..addColumns([transactions.amount.sum()])
      ..where(transactions.type.equalsValue(type))
      ..where(transactions.isDeleted.equals(false));

    if (userId != null) {
      query.where(transactions.userId.equals(userId));
    }

    final result = await query.getSingleOrNull();
    return result?.read(transactions.amount.sum()) ?? 0.0;
  }

  Future<double> calculateTotalIncome({String? userId}) {
    return _calculateTotalByType(TransactionType.income, userId: userId);
  }

  Future<double> calculateTotalExpenses({String? userId}) {
    return _calculateTotalByType(TransactionType.expense, userId: userId);
  }

  Future<double> calculateBalanceByPeriod(
    DateTime startDate,
    DateTime endDate, {
    String? userId,
  }) async {
    final income = await _calculateTotalByTypeAndPeriod(
      TransactionType.income,
      startDate,
      endDate,
      userId: userId,
    );
    final expense = await _calculateTotalByTypeAndPeriod(
      TransactionType.expense,
      startDate,
      endDate,
      userId: userId,
    );
    return income - expense;
  }

  Future<double> _calculateTotalByTypeAndPeriod(
    TransactionType type,
    DateTime startDate,
    DateTime endDate, {
    String? userId,
  }) async {
    final query = selectOnly(transactions)
      ..addColumns([transactions.amount.sum()])
      ..where(transactions.type.equalsValue(type))
      ..where(transactions.date.isBiggerOrEqualValue(startDate))
      ..where(transactions.date.isSmallerOrEqualValue(endDate))
      ..where(transactions.isDeleted.equals(false));

    if (userId != null) {
      query.where(transactions.userId.equals(userId));
    }

    final result = await query.getSingleOrNull();
    return result?.read(transactions.amount.sum()) ?? 0.0;
  }

  Future<double> calculateTotalByCategory(
    String category, {
    String? userId,
  }) async {
    final query = selectOnly(transactions)
      ..addColumns([transactions.amount.sum()])
      ..where(transactions.category.equals(category))
      ..where(transactions.isDeleted.equals(false));

    if (userId != null) {
      query.where(transactions.userId.equals(userId));
    }

    final result = await query.getSingleOrNull();
    return result?.read(transactions.amount.sum()) ?? 0.0;
  }

  Future<Map<String, double>> getCategoryDistribution({
    String? userId,
    TransactionType? type,
  }) async {
    try {
      final query = selectOnly(transactions)
        ..addColumns([transactions.category, transactions.amount.sum()])
        ..where(transactions.isDeleted.equals(false))
        ..groupBy([transactions.category]);

      if (userId != null) {
        query.where(transactions.userId.equals(userId));
      }

      if (type != null) {
        query.where(transactions.type.equalsValue(type));
      }

      final results = await query.get();
      final distribution = <String, double>{};

      for (final row in results) {
        final category = row.read(transactions.category);
        final total = row.read(transactions.amount.sum());

        if (category != null && total != null) {
          distribution[category] = total;
        }
      }

      return distribution;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> countTransactions({String? userId}) async {
    final query = selectOnly(transactions)
      ..addColumns([transactions.id.count()])
      ..where(transactions.isDeleted.equals(false));

    if (userId != null) {
      query.where(transactions.userId.equals(userId));
    }

    final result = await query.getSingleOrNull();
    return result?.read(transactions.id.count()) ?? 0;
  }

  Future<List<TransactionData>> getPendingSync({String? userId}) {
    final query = select(transactions)
      ..where((t) => t.syncedAt.isNull())
      ..where((t) => t.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm.asc(t.updatedAt)]);

    if (userId != null) {
      query..where((t) => t.userId.equals(userId));
    }

    return query.get();
  }

  Future<int> markAsSynced(String id) {
    return (update(transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        syncedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> updateSyncedAt(String id, DateTime syncedAt) {
    return (update(transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        syncedAt: Value(syncedAt),
      ),
    );
  }

  Future<void> insertMultiple(List<TransactionsCompanion> transactionsList) {
    return batch((batch) {
      batch.insertAll(transactions, transactionsList);
    });
  }

  Future<int> deleteOldTransactions(DateTime beforeDate) {
    return (delete(
      transactions,
    )..where((t) => t.date.isSmallerThanValue(beforeDate))).go();
  }

  Future<int> deleteAllByUser(String userId) {
    return (delete(transactions)..where((t) => t.userId.equals(userId))).go();
  }
}
