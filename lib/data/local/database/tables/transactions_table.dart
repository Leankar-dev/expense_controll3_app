import 'package:drift/drift.dart';
import '../../../enums/transaction_type.dart';
import '../../../enums/payment_method.dart';

@DataClassName('TransactionData')
class Transactions extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();

  RealColumn get amount => real().customConstraint(
    'CHECK (amount > 0.0 AND amount < 1000000000.0)',
  )();

  TextColumn get category => text().withLength(min: 1, max: 50)();

  TextColumn get description => text().withLength(min: 1, max: 500)();

  DateTimeColumn get date => dateTime()();

  IntColumn get paymentMethod => intEnum<PaymentMethod>()();

  IntColumn get type => intEnum<TransactionType>()();

  TextColumn get userId => text().withLength(min: 1, max: 255)();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>>? get uniqueKeys => [];
}
