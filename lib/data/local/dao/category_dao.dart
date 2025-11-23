import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/tables/categories_table.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  Future<int> insertCategory(CategoriesCompanion category) {
    return into(categories).insert(category);
  }

  Future<bool> updateCategory(Category category) {
    return update(categories).replace(category);
  }

  Future<int> deleteCategory(String id) {
    return (delete(categories)..where((c) => c.id.equals(id))).go();
  }

  Future<int> softDeleteCategory(String id) {
    return (update(categories)..where((c) => c.id.equals(id))).write(
      CategoriesCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> restoreCategory(String id) {
    return (update(categories)..where((c) => c.id.equals(id))).write(
      CategoriesCompanion(
        isDeleted: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<Category?> getCategoryById(String id) {
    return (select(
      categories,
    )..where((c) => c.id.equals(id))).getSingleOrNull();
  }

  Future<Category?> getCategoryByName(String name, {String? userId}) {
    final query = select(categories)
      ..where((c) => c.name.equals(name))
      ..where((c) => c.isDeleted.equals(false));

    if (userId != null) {
      query.where((c) => c.userId.equals(userId));
    }

    return query.getSingleOrNull();
  }

  Future<List<Category>> getAllCategories() {
    return select(categories).get();
  }

  Stream<List<Category>> watchAllCategories() {
    return (select(categories)
          ..where((c) => c.isDeleted.equals(false))
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .watch();
  }

  Future<List<Category>> getActiveCategories({String? userId}) {
    final query = select(categories)
      ..where((c) => c.isDeleted.equals(false))
      ..orderBy([(c) => OrderingTerm.asc(c.name)]);

    if (userId != null) {
      query.where((c) => c.userId.equals(userId));
    }

    return query.get();
  }

  Stream<List<Category>> watchActiveCategories({String? userId}) {
    final query = select(categories)
      ..where((c) => c.isDeleted.equals(false))
      ..orderBy([(c) => OrderingTerm.asc(c.name)]);

    if (userId != null) {
      query.where((c) => c.userId.equals(userId));
    }

    return query.watch();
  }

  Future<List<Category>> getCategoriesByUser(String userId) {
    return (select(categories)
          ..where((c) => c.userId.equals(userId))
          ..where((c) => c.isDeleted.equals(false))
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .get();
  }

  Stream<List<Category>> watchCategoriesByUser(String userId) {
    return (select(categories)
          ..where((c) => c.userId.equals(userId))
          ..where((c) => c.isDeleted.equals(false))
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .watch();
  }

  Future<List<Category>> getDefaultCategories() {
    return (select(categories)
          ..where((c) => c.isDefault.equals(true))
          ..where((c) => c.isDeleted.equals(false))
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .get();
  }

  Future<List<Category>> getCustomCategories({String? userId}) {
    final query = select(categories)
      ..where((c) => c.isDefault.equals(false))
      ..where((c) => c.isDeleted.equals(false))
      ..orderBy([(c) => OrderingTerm.asc(c.name)]);

    if (userId != null) {
      query.where((c) => c.userId.equals(userId));
    }

    return query.get();
  }

  Future<List<Category>> getCategoriesWithBudget({String? userId}) {
    final query = select(categories)
      ..where((c) => c.budgetLimit.isNotNull())
      ..where((c) => c.isDeleted.equals(false))
      ..orderBy([(c) => OrderingTerm.asc(c.name)]);

    if (userId != null) {
      query.where((c) => c.userId.equals(userId));
    }

    return query.get();
  }

  Stream<List<Category>> watchCategoriesWithBudget({String? userId}) {
    final query = select(categories)
      ..where((c) => c.budgetLimit.isNotNull())
      ..where((c) => c.isDeleted.equals(false))
      ..orderBy([(c) => OrderingTerm.asc(c.name)]);

    if (userId != null) {
      query.where((c) => c.userId.equals(userId));
    }

    return query.watch();
  }

  Future<List<Category>> searchCategories(
    String query, {
    String? userId,
  }) {
    final searchQuery = select(categories)
      ..where((c) => c.name.contains(query))
      ..where((c) => c.isDeleted.equals(false))
      ..orderBy([(c) => OrderingTerm.asc(c.name)]);

    if (userId != null) {
      searchQuery.where((c) => c.userId.equals(userId));
    }

    return searchQuery.get();
  }

  Future<bool> categoryExistsByName(String name, {String? userId}) async {
    final query = selectOnly(categories)
      ..addColumns([categories.id.count()])
      ..where(categories.name.equals(name))
      ..where(categories.isDeleted.equals(false));

    if (userId != null) {
      query.where(categories.userId.equals(userId));
    }

    final result = await query.getSingleOrNull();
    final count = result?.read(categories.id.count()) ?? 0;
    return count > 0;
  }

  Future<bool> categoryInUse(String categoryName) async {
    final query = selectOnly(db.transactions)
      ..addColumns([db.transactions.id.count()])
      ..where(db.transactions.category.equals(categoryName))
      ..where(db.transactions.isDeleted.equals(false));

    final result = await query.getSingleOrNull();
    final count = result?.read(db.transactions.id.count()) ?? 0;
    return count > 0;
  }

  Future<int> updateBudgetLimit(String id, double? budgetLimit) {
    return (update(categories)..where((c) => c.id.equals(id))).write(
      CategoriesCompanion(
        budgetLimit: Value(budgetLimit),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> updateColor(String id, String color) {
    return (update(categories)..where((c) => c.id.equals(id))).write(
      CategoriesCompanion(
        color: Value(color),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> updateIcon(String id, String icon) {
    return (update(categories)..where((c) => c.id.equals(id))).write(
      CategoriesCompanion(
        icon: Value(icon),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> countCategories({String? userId}) async {
    final query = selectOnly(categories)
      ..addColumns([categories.id.count()])
      ..where(categories.isDeleted.equals(false));

    if (userId != null) {
      query.where(categories.userId.equals(userId));
    }

    final result = await query.getSingleOrNull();
    return result?.read(categories.id.count()) ?? 0;
  }

  Future<int> countCustomCategories({String? userId}) async {
    final query = selectOnly(categories)
      ..addColumns([categories.id.count()])
      ..where(categories.isDefault.equals(false))
      ..where(categories.isDeleted.equals(false));

    if (userId != null) {
      query.where(categories.userId.equals(userId));
    }

    final result = await query.getSingleOrNull();
    return result?.read(categories.id.count()) ?? 0;
  }

  Future<List<Category>> getPendingSync({String? userId}) {
    final query = select(categories)
      ..where((c) => c.lastSyncedAt.isNull())
      ..orderBy([(c) => OrderingTerm.asc(c.updatedAt)]);

    if (userId != null) {
      query.where((c) => c.userId.equals(userId));
    }

    return query.get();
  }

  Future<int> markAsSynced(String id) {
    return (update(categories)..where((c) => c.id.equals(id))).write(
      CategoriesCompanion(
        lastSyncedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> updateSyncedAt(String id, DateTime syncedAt) {
    return (update(categories)..where((c) => c.id.equals(id))).write(
      CategoriesCompanion(
        lastSyncedAt: Value(syncedAt),
      ),
    );
  }

  Future<void> insertMultiple(List<CategoriesCompanion> categoriesList) {
    return batch((batch) {
      batch.insertAll(categories, categoriesList);
    });
  }

  Future<int> deleteUnusedCategories() async {
    final allCategories =
        await (select(categories)
              ..where((c) => c.isDeleted.equals(false))
              ..where((c) => c.isDefault.equals(false)))
            .get();

    int deletedCount = 0;

    for (final category in allCategories) {
      final inUse = await categoryInUse(category.name);
      if (!inUse) {
        await deleteCategory(category.id);
        deletedCount++;
      }
    }

    return deletedCount;
  }

  Future<int> deleteAllCustomByUser(String userId) {
    return (delete(categories)
          ..where((c) => c.userId.equals(userId))
          ..where((c) => c.isDefault.equals(false)))
        .go();
  }

  Future<void> restoreDefaultCategories(
    String userId,
    List<CategoriesCompanion> defaultCategories,
  ) async {
    await (delete(categories)
          ..where((c) => c.userId.equals(userId))
          ..where((c) => c.isDefault.equals(true)))
        .go();

    await insertMultiple(defaultCategories);
  }
}
