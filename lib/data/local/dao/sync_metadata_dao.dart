import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/tables/sync_metadata_table.dart';

part 'sync_metadata_dao.g.dart';

@DriftAccessor(tables: [SyncMetadata])
class SyncMetadataDao extends DatabaseAccessor<AppDatabase>
    with _$SyncMetadataDaoMixin {
  SyncMetadataDao(super.db);

  Future<int> upsertMetadata(SyncMetadataCompanion metadata) {
    return into(syncMetadata).insertOnConflictUpdate(metadata);
  }

  Future<int> insertMetadata(SyncMetadataCompanion metadata) {
    return into(syncMetadata).insert(metadata);
  }

  Future<bool> updateMetadata(SyncMetadataData metadata) {
    return update(syncMetadata).replace(metadata);
  }

  Future<int> deleteMetadata(String entityId, String entityType) {
    return (delete(syncMetadata)
          ..where((m) => m.entityId.equals(entityId))
          ..where((m) => m.entityType.equals(entityType)))
        .go();
  }

  Future<SyncMetadataData?> getMetadata(String entityId, String entityType) {
    return (select(syncMetadata)
          ..where((m) => m.entityId.equals(entityId))
          ..where((m) => m.entityType.equals(entityType)))
        .getSingleOrNull();
  }

  Future<List<SyncMetadataData>> getAllMetadata() {
    return select(syncMetadata).get();
  }

  Future<List<SyncMetadataData>> getMetadataByType(String entityType) {
    return (select(
      syncMetadata,
    )..where((m) => m.entityType.equals(entityType))).get();
  }

  Future<List<SyncMetadataData>> getPendingSync({String? entityType}) {
    final query = select(syncMetadata)
      ..where((m) => m.syncStatus.equalsValue(SyncStatus.pending))
      ..orderBy([(m) => OrderingTerm.asc(m.lastSyncedAt)]);

    if (entityType != null) {
      query.where((m) => m.entityType.equals(entityType));
    }

    return query.get();
  }

  Stream<List<SyncMetadataData>> watchPendingSync({String? entityType}) {
    final query = select(syncMetadata)
      ..where((m) => m.syncStatus.equalsValue(SyncStatus.pending))
      ..orderBy([(m) => OrderingTerm.asc(m.lastSyncedAt)]);

    if (entityType != null) {
      query.where((m) => m.entityType.equals(entityType));
    }

    return query.watch();
  }

  Future<List<SyncMetadataData>> getConflicts({String? entityType}) {
    final query = select(syncMetadata)
      ..where((m) => m.syncStatus.equalsValue(SyncStatus.conflict))
      ..orderBy([(m) => OrderingTerm.desc(m.lastSyncedAt)]);

    if (entityType != null) {
      query.where((m) => m.entityType.equals(entityType));
    }

    return query.get();
  }

  Stream<List<SyncMetadataData>> watchConflicts({String? entityType}) {
    final query = select(syncMetadata)
      ..where((m) => m.syncStatus.equalsValue(SyncStatus.conflict))
      ..orderBy([(m) => OrderingTerm.desc(m.lastSyncedAt)]);

    if (entityType != null) {
      query.where((m) => m.entityType.equals(entityType));
    }

    return query.watch();
  }

  Future<List<SyncMetadataData>> getErrors({String? entityType}) {
    final query = select(syncMetadata)
      ..where((m) => m.syncStatus.equalsValue(SyncStatus.error))
      ..orderBy([(m) => OrderingTerm.desc(m.lastSyncedAt)]);

    if (entityType != null) {
      query.where((m) => m.entityType.equals(entityType));
    }

    return query.get();
  }

  Future<List<SyncMetadataData>> getSynced({String? entityType}) {
    final query = select(syncMetadata)
      ..where((m) => m.syncStatus.equalsValue(SyncStatus.synced))
      ..orderBy([(m) => OrderingTerm.desc(m.lastSyncedAt)]);

    if (entityType != null) {
      query.where((m) => m.entityType.equals(entityType));
    }

    return query.get();
  }

  Future<int> updateSyncStatus(
    String entityId,
    String entityType,
    SyncStatus status, {
    String? errorMessage,
    String? conflictData,
  }) {
    return (update(syncMetadata)
          ..where((m) => m.entityId.equals(entityId))
          ..where((m) => m.entityType.equals(entityType)))
        .write(
          SyncMetadataCompanion(
            syncStatus: Value(status),
            lastSyncedAt: Value(DateTime.now()),
            errorMessage: Value(errorMessage),
            conflictData: Value(conflictData),
          ),
        );
  }

  Future<int> markAsSynced(String entityId, String entityType) {
    return updateSyncStatus(entityId, entityType, SyncStatus.synced);
  }

  Future<int> markAsPending(String entityId, String entityType) {
    return updateSyncStatus(entityId, entityType, SyncStatus.pending);
  }

  Future<int> markAsError(
    String entityId,
    String entityType,
    String errorMessage,
  ) {
    return updateSyncStatus(
      entityId,
      entityType,
      SyncStatus.error,
      errorMessage: errorMessage,
    );
  }

  Future<int> markAsConflict(
    String entityId,
    String entityType,
    String conflictData,
  ) {
    return updateSyncStatus(
      entityId,
      entityType,
      SyncStatus.conflict,
      conflictData: conflictData,
    );
  }

  Future<int> incrementRetryCount(String entityId, String entityType) async {
    final current = await getMetadata(entityId, entityType);
    if (current == null) return 0;

    return (update(syncMetadata)
          ..where((m) => m.entityId.equals(entityId))
          ..where((m) => m.entityType.equals(entityType)))
        .write(
          SyncMetadataCompanion(
            retryCount: Value(current.retryCount + 1),
          ),
        );
  }

  Future<int> resetRetryCount(String entityId, String entityType) {
    return (update(syncMetadata)
          ..where((m) => m.entityId.equals(entityId))
          ..where((m) => m.entityType.equals(entityType)))
        .write(
          const SyncMetadataCompanion(
            retryCount: Value(0),
          ),
        );
  }

  Future<bool> needsSync(String entityId, String entityType) async {
    final metadata = await getMetadata(entityId, entityType);
    if (metadata == null) return true;

    return metadata.syncStatus != SyncStatus.synced;
  }

  Future<bool> hasPendingSync({String? entityType}) async {
    final pending = await getPendingSync(entityType: entityType);
    return pending.isNotEmpty;
  }

  Future<bool> hasConflicts({String? entityType}) async {
    final conflicts = await getConflicts(entityType: entityType);
    return conflicts.isNotEmpty;
  }

  Future<int> countByStatus(SyncStatus status, {String? entityType}) async {
    final query = selectOnly(syncMetadata)
      ..addColumns([syncMetadata.entityId.count()])
      ..where(syncMetadata.syncStatus.equalsValue(status));

    if (entityType != null) {
      query.where(syncMetadata.entityType.equals(entityType));
    }

    final result = await query.getSingleOrNull();
    return result?.read(syncMetadata.entityId.count()) ?? 0;
  }

  Future<int> countAll({String? entityType}) async {
    final query = selectOnly(syncMetadata)
      ..addColumns([syncMetadata.entityId.count()]);

    if (entityType != null) {
      query.where(syncMetadata.entityType.equals(entityType));
    }

    final result = await query.getSingleOrNull();
    return result?.read(syncMetadata.entityId.count()) ?? 0;
  }

  Future<SyncSummary> getSyncSummary({String? entityType}) async {
    return SyncSummary(
      total: await countAll(entityType: entityType),
      synced: await countByStatus(SyncStatus.synced, entityType: entityType),
      pending: await countByStatus(SyncStatus.pending, entityType: entityType),
      conflicts: await countByStatus(
        SyncStatus.conflict,
        entityType: entityType,
      ),
      errors: await countByStatus(SyncStatus.error, entityType: entityType),
    );
  }

  Future<int> cleanOldSyncedMetadata(DateTime beforeDate) {
    return (delete(syncMetadata)
          ..where((m) => m.syncStatus.equalsValue(SyncStatus.synced))
          ..where((m) => m.lastSyncedAt.isSmallerThanValue(beforeDate)))
        .go();
  }

  Future<int> deleteAllByType(String entityType) {
    return (delete(
      syncMetadata,
    )..where((m) => m.entityType.equals(entityType))).go();
  }

  Future<void> resetAll({String? entityType}) async {
    final query = update(syncMetadata);

    if (entityType != null) {
      query.where((m) => m.entityType.equals(entityType));
    }

    await query.write(
      SyncMetadataCompanion(
        syncStatus: const Value(SyncStatus.pending),
        retryCount: const Value(0),
        errorMessage: const Value(null),
        conflictData: const Value(null),
      ),
    );
  }

  Future<int> cleanOrphanedMetadata(
    List<String> validEntityIds,
    String entityType,
  ) {
    return (delete(syncMetadata)
          ..where((m) => m.entityType.equals(entityType))
          ..where((m) => m.entityId.isNotIn(validEntityIds)))
        .go();
  }
}

class SyncSummary {
  final int total;
  final int synced;
  final int pending;
  final int conflicts;
  final int errors;

  const SyncSummary({
    required this.total,
    required this.synced,
    required this.pending,
    required this.conflicts,
    required this.errors,
  });

  double get syncedPercentage => total > 0 ? (synced / total) * 100 : 0;

  bool get isFullySynced => total > 0 && synced == total;

  bool get hasIssues => conflicts > 0 || errors > 0;

  @override
  String toString() {
    return 'SyncSummary(total: $total, synced: $synced, pending: $pending, '
        'conflicts: $conflicts, errors: $errors)';
  }
}
