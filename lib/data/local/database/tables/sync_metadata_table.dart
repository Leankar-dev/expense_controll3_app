import 'package:drift/drift.dart';

enum SyncStatus {
  synced,
  pending,
  conflict,
  error,
}

@DataClassName('SyncMetadataData')
class SyncMetadata extends Table {
  TextColumn get entityId => text().withLength(min: 1, max: 255)();

  TextColumn get entityType => text().withLength(min: 1, max: 50)();

  DateTimeColumn get lastSyncedAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();

  IntColumn get syncStatus =>
      intEnum<SyncStatus>().withDefault(const Constant(1))();

  TextColumn get conflictData => text().nullable()();

  IntColumn get retryCount => integer().withDefault(const Constant(0))();

  TextColumn get errorMessage => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();

  @override
  Set<Column> get primaryKey => {entityId, entityType};

  @override
  List<Set<Column>> get uniqueKeys => [
    {entityId, entityType},
  ];

  @override
  List<String> get customConstraints => [
    'CREATE INDEX IF NOT EXISTS idx_sync_status_type ON sync_metadata(sync_status, entity_type)',

    'CREATE INDEX IF NOT EXISTS idx_sync_last_synced ON sync_metadata(last_synced_at DESC)',

    'CREATE INDEX IF NOT EXISTS idx_sync_retry ON sync_metadata(retry_count) WHERE retry_count > 0',
  ];
}
