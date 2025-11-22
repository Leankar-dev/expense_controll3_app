class SyncMetadataModel {
  final String entityId;
  final String entityType;
  final DateTime lastSyncedAt;
  final SyncStatus syncStatus;
  final String? conflictData;
  final int retryCount;
  final String? errorMessage;

  const SyncMetadataModel({
    required this.entityId,
    required this.entityType,
    required this.lastSyncedAt,
    required this.syncStatus,
    this.conflictData,
    this.retryCount = 0,
    this.errorMessage,
  });

  bool get isSynced => syncStatus == SyncStatus.synced;

  bool get isPending => syncStatus == SyncStatus.pending;

  bool get hasConflict => syncStatus == SyncStatus.conflict;

  bool get hasError => syncStatus == SyncStatus.error;

  bool get canRetry => retryCount < SyncMetadataModel.maxRetries;

  static const int maxRetries = 3;

  SyncMetadataModel copyWith({
    String? entityId,
    String? entityType,
    DateTime? lastSyncedAt,
    SyncStatus? syncStatus,
    String? conflictData,
    int? retryCount,
    String? errorMessage,
  }) {
    return SyncMetadataModel(
      entityId: entityId ?? this.entityId,
      entityType: entityType ?? this.entityType,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      conflictData: conflictData ?? this.conflictData,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entityId': entityId,
      'entityType': entityType,
      'lastSyncedAt': lastSyncedAt.toIso8601String(),
      'syncStatus': syncStatus.name,
      'conflictData': conflictData,
      'retryCount': retryCount,
      'errorMessage': errorMessage,
    };
  }

  factory SyncMetadataModel.fromJson(Map<String, dynamic> json) {
    return SyncMetadataModel(
      entityId: json['entityId'] as String,
      entityType: json['entityType'] as String,
      lastSyncedAt: DateTime.parse(json['lastSyncedAt'] as String),
      syncStatus: SyncStatus.fromString(json['syncStatus'] as String),
      conflictData: json['conflictData'] as String?,
      retryCount: json['retryCount'] as int? ?? 0,
      errorMessage: json['errorMessage'] as String?,
    );
  }

  factory SyncMetadataModel.create({
    required String entityId,
    required String entityType,
  }) {
    return SyncMetadataModel(
      entityId: entityId,
      entityType: entityType,
      lastSyncedAt: DateTime.now(),
      syncStatus: SyncStatus.pending,
      retryCount: 0,
    );
  }

  SyncMetadataModel markAsSynced() {
    return copyWith(
      lastSyncedAt: DateTime.now(),
      syncStatus: SyncStatus.synced,
      retryCount: 0,
      errorMessage: null,
      conflictData: null,
    );
  }

  SyncMetadataModel markAsPending() {
    return copyWith(
      syncStatus: SyncStatus.pending,
    );
  }

  SyncMetadataModel markAsError(String message) {
    return copyWith(
      syncStatus: SyncStatus.error,
      errorMessage: message,
      retryCount: retryCount + 1,
    );
  }

  SyncMetadataModel markAsConflict(String conflictDataJson) {
    return copyWith(
      syncStatus: SyncStatus.conflict,
      conflictData: conflictDataJson,
    );
  }

  SyncMetadataModel resolveConflict() {
    return copyWith(
      syncStatus: SyncStatus.synced,
      conflictData: null,
      lastSyncedAt: DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SyncMetadataModel &&
        other.entityId == entityId &&
        other.entityType == entityType;
  }

  @override
  int get hashCode => Object.hash(entityId, entityType);

  @override
  String toString() {
    return 'SyncMetadataModel(entityId: $entityId, entityType: $entityType, '
        'syncStatus: ${syncStatus.name})';
  }
}

enum SyncStatus {
  synced,

  pending,

  conflict,

  error
  ;

  String get displayName {
    return switch (this) {
      SyncStatus.synced => 'Sincronizado',
      SyncStatus.pending => 'Pendente',
      SyncStatus.conflict => 'Conflito',
      SyncStatus.error => 'Erro',
    };
  }

  String get colorHex {
    return switch (this) {
      SyncStatus.synced => '#22C55E',
      SyncStatus.pending => '#F59E0B',
      SyncStatus.conflict => '#EF4444',
      SyncStatus.error => '#EF4444',
    };
  }

  static SyncStatus fromString(String value) {
    return SyncStatus.values.firstWhere(
      (status) => status.name.toLowerCase() == value.toLowerCase(),
      orElse: () => SyncStatus.pending,
    );
  }

  static SyncStatus fromIndex(int index) {
    if (index < 0 || index >= SyncStatus.values.length) {
      return SyncStatus.pending;
    }
    return SyncStatus.values[index];
  }
}

abstract final class SyncEntityType {
  static const String transaction = 'transaction';
  static const String category = 'category';

  static const List<String> all = [transaction, category];

  static bool isValid(String type) => all.contains(type);
}

class SyncResult {
  final bool success;

  final int syncedCount;

  final int conflictCount;

  final int errorCount;

  final String? errorMessage;

  final DateTime timestamp;

  const SyncResult({
    required this.success,
    this.syncedCount = 0,
    this.conflictCount = 0,
    this.errorCount = 0,
    this.errorMessage,
    required this.timestamp,
  });

  factory SyncResult.success({
    int syncedCount = 0,
    int conflictCount = 0,
  }) {
    return SyncResult(
      success: true,
      syncedCount: syncedCount,
      conflictCount: conflictCount,
      timestamp: DateTime.now(),
    );
  }

  factory SyncResult.error(String message, {int errorCount = 1}) {
    return SyncResult(
      success: false,
      errorCount: errorCount,
      errorMessage: message,
      timestamp: DateTime.now(),
    );
  }

  bool get hasConflicts => conflictCount > 0;

  bool get hasErrors => errorCount > 0;

  int get totalProcessed => syncedCount + conflictCount + errorCount;

  @override
  String toString() {
    return 'SyncResult(success: $success, synced: $syncedCount, '
        'conflicts: $conflictCount, errors: $errorCount)';
  }
}
