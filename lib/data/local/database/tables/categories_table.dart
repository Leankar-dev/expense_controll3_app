import 'package:drift/drift.dart';

@DataClassName('Category')
class Categories extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();

  TextColumn get name => text().withLength(min: 1, max: 100)();

  TextColumn get description =>
      text().withLength(min: 0, max: 255).nullable()();

  TextColumn get type => text().withLength(min: 6, max: 7)();

  TextColumn get icon => text().withLength(min: 1, max: 100)();

  TextColumn get color => text().withLength(min: 7, max: 9)();

  RealColumn get budgetLimit => real().nullable()();

  TextColumn get userId => text().withLength(min: 1, max: 255)();

  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  IntColumn get displayOrder => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {userId, name, type},
  ];

  @override
  List<String> get customConstraints => [
    "CHECK (type IN ('income', 'expense'))",

    "CHECK (color GLOB '#[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]' OR color GLOB '#[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]')",

    "CHECK (budget_limit IS NULL OR (budget_limit >= 0 AND budget_limit <= 999999999.99))",
  ];
}
