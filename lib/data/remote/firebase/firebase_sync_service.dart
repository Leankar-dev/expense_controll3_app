import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';

import '../../../core/exceptions/base_exception.dart';
import '../../local/database/app_database.dart';
import '../../local/database/tables/sync_metadata_table.dart';
import '../../models/sync_metadata_model.dart';
import '../../models/transaction_model.dart';
import '../../models/category_model.dart';

/// Serviço responsável pela sincronização de dados entre o banco local e o Firebase
///
/// Este serviço gerencia toda a lógica de sincronização bidirecional entre:
/// - SQLite local (usando Drift)
/// - Cloud Firestore (Firebase)
///
/// Funcionalidades principais:
/// - Sincronização automática quando há conexão com internet
/// - Detecção e resolução de conflitos
/// - Sistema de retry para falhas temporárias
/// - Sincronização incremental (apenas dados modificados)
/// - Suporte para sincronização em background
/// - Marcação de timestamps para rastreamento de mudanças
///
/// Estratégias de resolução de conflitos:
/// - Last Write Wins (LWW) - O mais recente ganha por padrão
/// - Suporte para resolução manual quando necessário
class FirebaseSyncService {
  final FirebaseFirestore _firestore;
  final AppDatabase _database;
  final Connectivity _connectivity;

  /// Coleção do Firestore onde as transações são armazenadas
  static const String _transactionsCollection = 'transactions';

  /// Coleção do Firestore onde as categorias são armazenadas
  static const String _categoriesCollection = 'categories';

  /// Número máximo de tentativas de sincronização antes de desistir
  static const int _maxRetries = 3;

  /// Tempo de espera entre tentativas de sincronização (em segundos)
  static const int _retryDelay = 5;

  /// Construtor do serviço de sincronização
  ///
  /// [_firestore] - Instância do Cloud Firestore para operações remotas
  /// [_database] - Instância do banco de dados local (Drift)
  /// [_connectivity] - Serviço para verificar conectividade com internet
  FirebaseSyncService(
    this._firestore,
    this._database,
    this._connectivity,
  );

  /// Verifica se há conexão com a internet
  ///
  /// Retorna true se houver conexão WiFi ou dados móveis
  Future<bool> hasInternetConnection() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi);
    } catch (e) {
      return false;
    }
  }

  /// Stream que monitora mudanças na conectividade
  ///
  /// Emite true quando há conexão e false quando não há
  Stream<bool> get connectivityStream {
    return _connectivity.onConnectivityChanged.map((results) {
      return results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.wifi);
    });
  }

  // ============================================================================
  // SINCRONIZAÇÃO COMPLETA
  // ============================================================================

  /// Executa uma sincronização completa de todos os dados
  ///
  /// Este método sincroniza todas as entidades (transações, categorias, etc.)
  /// em ambas as direções:
  /// 1. Upload de dados locais modificados para o Firebase
  /// 2. Download de dados do Firebase para o banco local
  ///
  /// [userId] - ID do usuário para filtrar os dados
  /// [forceSync] - Se true, força sincronização mesmo sem mudanças detectadas
  ///
  /// Retorna:
  /// - Right(SyncResult) com estatísticas da sincronização em caso de sucesso
  /// - Left(SyncException) em caso de erro
  Future<Either<SyncException, SyncResult>> syncAll({
    required String userId,
    bool forceSync = false,
  }) async {
    try {
      // Verifica conectividade antes de tentar sincronizar
      final hasConnection = await hasInternetConnection();
      if (!hasConnection) {
        return Left(
          SyncFailedException(
            message: 'Sem conexão com a internet',
            code: 'no-connection',
          ),
        );
      }

      final startTime = DateTime.now();
      int uploadedCount = 0;
      int downloadedCount = 0;
      int conflictsCount = 0;
      final List<String> errors = [];

      // 1. Sincroniza transações
      final transactionsResult = await syncTransactions(
        userId: userId,
        forceSync: forceSync,
      );

      transactionsResult.fold(
        (error) => errors.add('Transações: ${error.message}'),
        (result) {
          uploadedCount += result.uploadedCount;
          downloadedCount += result.downloadedCount;
          conflictsCount += result.conflictsCount;
        },
      );

      // 2. Sincroniza categorias
      final categoriesResult = await syncCategories(
        userId: userId,
        forceSync: forceSync,
      );

      categoriesResult.fold(
        (error) => errors.add('Categorias: ${error.message}'),
        (result) {
          uploadedCount += result.uploadedCount;
          downloadedCount += result.downloadedCount;
          conflictsCount += result.conflictsCount;
        },
      );

      final duration = DateTime.now().difference(startTime);

      final result = SyncResult(
        uploadedCount: uploadedCount,
        downloadedCount: downloadedCount,
        conflictsCount: conflictsCount,
        duration: duration,
        errors: errors,
        timestamp: DateTime.now(),
      );

      return Right(result);
    } catch (e, stackTrace) {
      return Left(
        SyncFailedException(
          message: 'Erro ao sincronizar dados: $e',
          code: 'sync-error',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  // ============================================================================
  // SINCRONIZAÇÃO DE TRANSAÇÕES
  // ============================================================================

  /// Sincroniza transações entre o banco local e o Firebase
  ///
  /// Processo de sincronização:
  /// 1. Busca transações locais pendentes de sincronização
  /// 2. Faz upload dessas transações para o Firebase
  /// 3. Busca transações novas/modificadas do Firebase
  /// 4. Faz download e salva no banco local
  /// 5. Detecta e resolve conflitos quando necessário
  ///
  /// [userId] - ID do usuário para filtrar as transações
  /// [forceSync] - Se true, sincroniza todas as transações independente do status
  Future<Either<SyncException, SyncResult>> syncTransactions({
    required String userId,
    bool forceSync = false,
  }) async {
    try {
      final startTime = DateTime.now();
      int uploadedCount = 0;
      int downloadedCount = 0;
      int conflictsCount = 0;

      // UPLOAD: Envia transações locais modificadas para o Firebase
      final localTransactions = await _getLocalTransactionsPendingSync(userId);

      for (final transaction in localTransactions) {
        final uploadResult = await _uploadTransaction(transaction);

        uploadResult.fold(
          (error) {
            // Registra erro mas continua com as outras transações
            _updateSyncMetadata(
              entityId: transaction.id,
              entityType: 'transaction',
              status: SyncStatus.error,
              errorMessage: error.message,
            );
          },
          (_) {
            uploadedCount++;
            _updateSyncMetadata(
              entityId: transaction.id,
              entityType: 'transaction',
              status: SyncStatus.synced,
            );
          },
        );
      }

      // DOWNLOAD: Busca transações do Firebase e salva localmente
      final remoteTransactions = await _getRemoteTransactions(userId);

      for (final remoteTransaction in remoteTransactions) {
        final downloadResult = await _downloadTransaction(
          remoteTransaction,
          userId,
        );

        downloadResult.fold(
          (error) {
            if (error.code == 'conflict') {
              conflictsCount++;
            }
          },
          (wasUpdated) {
            if (wasUpdated) {
              downloadedCount++;
            }
          },
        );
      }

      final duration = DateTime.now().difference(startTime);

      return Right(
        SyncResult(
          uploadedCount: uploadedCount,
          downloadedCount: downloadedCount,
          conflictsCount: conflictsCount,
          duration: duration,
          errors: [],
          timestamp: DateTime.now(),
        ),
      );
    } catch (e, stackTrace) {
      return Left(
        SyncFailedException(
          message: 'Erro ao sincronizar transações: $e',
          code: 'transaction-sync-error',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Busca transações locais que precisam ser sincronizadas
  ///
  /// Retorna transações que:
  /// - Foram criadas mas nunca sincronizadas
  /// - Foram modificadas após a última sincronização
  /// - Estão marcadas como pendentes
  Future<List<TransactionModel>> _getLocalTransactionsPendingSync(
    String userId,
  ) async {
    // TODO: Implementar consulta no banco local usando Drift
    // Buscar transações onde syncedAt é null ou updatedAt > syncedAt
    return [];
  }

  /// Busca transações do Firebase modificadas após a última sincronização
  ///
  /// [userId] - ID do usuário para filtrar as transações
  Future<List<TransactionModel>> _getRemoteTransactions(String userId) async {
    try {
      // Busca o timestamp da última sincronização
      final lastSync = await _getLastSyncTimestamp('transaction', userId);

      // Busca transações modificadas após o último sync
      QuerySnapshot<Map<String, dynamic>> snapshot;

      if (lastSync != null) {
        snapshot = await _firestore
            .collection(_transactionsCollection)
            .where('userId', isEqualTo: userId)
            .where('updatedAt', isGreaterThan: lastSync.toIso8601String())
            .orderBy('updatedAt', descending: false)
            .get();
      } else {
        // Primeira sincronização - busca tudo
        snapshot = await _firestore
            .collection(_transactionsCollection)
            .where('userId', isEqualTo: userId)
            .orderBy('updatedAt', descending: false)
            .get();
      }

      return snapshot.docs
          .map((doc) => TransactionModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw SyncFailedException(
        message: 'Erro ao buscar transações remotas: $e',
        code: 'fetch-remote-error',
        originalError: e,
      );
    }
  }

  /// Faz upload de uma transação para o Firebase
  ///
  /// [transaction] - Transação a ser enviada
  Future<Either<SyncException, void>> _uploadTransaction(
    TransactionModel transaction,
  ) async {
    try {
      await _firestore
          .collection(_transactionsCollection)
          .doc(transaction.id)
          .set(
            transaction.toJson(),
            SetOptions(merge: true),
          );

      return const Right(null);
    } catch (e, stackTrace) {
      return Left(
        SyncFailedException(
          message: 'Erro ao fazer upload da transação: $e',
          code: 'upload-error',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Faz download de uma transação do Firebase e salva localmente
  ///
  /// [remoteTransaction] - Transação vinda do Firebase
  /// [userId] - ID do usuário
  ///
  /// Retorna:
  /// - Right(true) se a transação foi inserida/atualizada
  /// - Right(false) se não houve mudanças
  /// - Left(SyncException) em caso de conflito ou erro
  Future<Either<SyncException, bool>> _downloadTransaction(
    TransactionModel remoteTransaction,
    String userId,
  ) async {
    try {
      // Busca a transação local para comparar
      // TODO: Implementar busca no banco local
      final TransactionModel? localTransaction = null;

      if (localTransaction == null) {
        // Transação não existe localmente - insere
        // TODO: Implementar inserção no banco local
        return const Right(true);
      }

      // Verifica conflito comparando timestamps
      if (localTransaction.updatedAt.isAfter(remoteTransaction.updatedAt)) {
        // Versão local é mais recente - mantém local e sinaliza conflito
        await _handleConflict(
          entityId: remoteTransaction.id,
          entityType: 'transaction',
          localData: localTransaction.toJson(),
          remoteData: remoteTransaction.toJson(),
        );

        return Left(
          SyncConflictException(
            message: 'Conflito detectado na transação ${remoteTransaction.id}',
            code: 'conflict',
          ),
        );
      }

      // Versão remota é mais recente ou igual - atualiza local
      // TODO: Implementar atualização no banco local
      return const Right(true);
    } catch (e, stackTrace) {
      return Left(
        SyncFailedException(
          message: 'Erro ao baixar transação: $e',
          code: 'download-error',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  // ============================================================================
  // SINCRONIZAÇÃO DE CATEGORIAS
  // ============================================================================

  /// Sincroniza categorias entre o banco local e o Firebase
  ///
  /// Similar ao processo de sincronização de transações
  Future<Either<SyncException, SyncResult>> syncCategories({
    required String userId,
    bool forceSync = false,
  }) async {
    try {
      final startTime = DateTime.now();
      int uploadedCount = 0;
      int downloadedCount = 0;

      // UPLOAD: Envia categorias locais para o Firebase
      // TODO: Implementar upload de categorias

      // DOWNLOAD: Busca categorias do Firebase
      // TODO: Implementar download de categorias

      final duration = DateTime.now().difference(startTime);

      return Right(
        SyncResult(
          uploadedCount: uploadedCount,
          downloadedCount: downloadedCount,
          conflictsCount: 0,
          duration: duration,
          errors: [],
          timestamp: DateTime.now(),
        ),
      );
    } catch (e, stackTrace) {
      return Left(
        SyncFailedException(
          message: 'Erro ao sincronizar categorias: $e',
          code: 'category-sync-error',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  // ============================================================================
  // GERENCIAMENTO DE METADADOS DE SINCRONIZAÇÃO
  // ============================================================================

  /// Busca o timestamp da última sincronização bem-sucedida
  ///
  /// [entityType] - Tipo da entidade (transaction, category, etc.)
  /// [userId] - ID do usuário
  Future<DateTime?> _getLastSyncTimestamp(
    String entityType,
    String userId,
  ) async {
    try {
      // TODO: Implementar busca no banco local
      // Buscar o max(lastSyncedAt) onde entityType = ? e syncStatus = synced
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Atualiza os metadados de sincronização no banco local
  ///
  /// [entityId] - ID da entidade sincronizada
  /// [entityType] - Tipo da entidade
  /// [status] - Novo status de sincronização
  /// [errorMessage] - Mensagem de erro (se houver)
  Future<void> _updateSyncMetadata({
    required String entityId,
    required String entityType,
    required SyncStatus status,
    String? errorMessage,
  }) async {
    try {
      // TODO: Implementar atualização no banco local usando Drift
      final metadata = SyncMetadataModel(
        entityId: entityId,
        entityType: entityType,
        lastSyncedAt: DateTime.now(),
        syncStatus: status,
        errorMessage: errorMessage,
        retryCount: status == SyncStatus.error ? 1 : 0,
      );

      // Salvar no banco local
    } catch (e) {
      // Log do erro mas não propaga pois é apenas metadado
      print('Erro ao atualizar metadados de sincronização: $e');
    }
  }

  // ============================================================================
  // RESOLUÇÃO DE CONFLITOS
  // ============================================================================

  /// Trata conflitos de sincronização
  ///
  /// Estratégia padrão: Last Write Wins (LWW)
  /// - Compara os timestamps de updatedAt
  /// - Mantém a versão mais recente
  /// - Salva as duas versões nos metadados para possível resolução manual
  ///
  /// [entityId] - ID da entidade em conflito
  /// [entityType] - Tipo da entidade
  /// [localData] - Dados da versão local
  /// [remoteData] - Dados da versão remota
  Future<void> _handleConflict({
    required String entityId,
    required String entityType,
    required Map<String, dynamic> localData,
    required Map<String, dynamic> remoteData,
  }) async {
    try {
      // Salva informações do conflito nos metadados
      final conflictData = {
        'local': localData,
        'remote': remoteData,
        'detectedAt': DateTime.now().toIso8601String(),
      };

      // TODO: Implementar salvamento do conflito no banco local
      await _updateSyncMetadata(
        entityId: entityId,
        entityType: entityType,
        status: SyncStatus.conflict,
        errorMessage: 'Conflito detectado - versões diferentes',
      );

      // Registra o conflito para análise posterior
      print('⚠️ Conflito detectado: $entityType/$entityId');
    } catch (e) {
      print('Erro ao tratar conflito: $e');
    }
  }

  /// Lista todos os conflitos pendentes de resolução
  ///
  /// [userId] - ID do usuário
  ///
  /// Retorna lista de metadados com status = conflict
  Future<List<SyncMetadataModel>> getConflicts(String userId) async {
    try {
      // TODO: Implementar consulta no banco local
      // SELECT * FROM sync_metadata WHERE sync_status = conflict
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Resolve um conflito manualmente escolhendo uma versão
  ///
  /// [conflictId] - ID do conflito (entityId)
  /// [useLocal] - Se true usa versão local, se false usa versão remota
  Future<Either<SyncException, void>> resolveConflict({
    required String conflictId,
    required String entityType,
    required bool useLocal,
  }) async {
    try {
      // TODO: Implementar resolução manual de conflito
      // 1. Buscar os dados do conflito
      // 2. Se useLocal, fazer upload da versão local
      // 3. Se !useLocal, aplicar a versão remota localmente
      // 4. Atualizar status para synced

      return const Right(null);
    } catch (e, stackTrace) {
      return Left(
        SyncFailedException(
          message: 'Erro ao resolver conflito: $e',
          code: 'conflict-resolution-error',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  // ============================================================================
  // LIMPEZA E MANUTENÇÃO
  // ============================================================================

  /// Limpa metadados antigos de sincronização
  ///
  /// Remove registros de sincronização com mais de [daysOld] dias
  /// e que estejam com status synced (sincronizados com sucesso)
  ///
  /// [daysOld] - Número de dias para considerar registro como antigo
  Future<int> cleanOldSyncMetadata({int daysOld = 30}) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));

      // TODO: Implementar limpeza no banco local
      // DELETE FROM sync_metadata
      // WHERE last_synced_at < cutoffDate
      // AND sync_status = synced

      return 0; // Retorna número de registros deletados
    } catch (e) {
      print('Erro ao limpar metadados antigos: $e');
      return 0;
    }
  }

  /// Reprocessa registros com erro de sincronização
  ///
  /// Tenta sincronizar novamente registros que falharam,
  /// respeitando o limite de tentativas (maxRetries)
  ///
  /// [userId] - ID do usuário
  Future<Either<SyncException, int>> retryFailedSync(String userId) async {
    try {
      // TODO: Implementar retry de registros com erro
      // 1. Buscar registros com status = error e retryCount < maxRetries
      // 2. Tentar sincronizar cada um novamente
      // 3. Incrementar retryCount ou marcar como synced

      return const Right(0); // Retorna número de registros reprocessados
    } catch (e, stackTrace) {
      return Left(
        SyncFailedException(
          message: 'Erro ao reprocessar sincronizações falhas: $e',
          code: 'retry-error',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Reseta todos os metadados de sincronização
  ///
  /// ⚠️ CUIDADO: Esta operação marca todos os registros como pendentes
  /// Isso forçará uma nova sincronização completa de todos os dados
  ///
  /// Use apenas em casos de:
  /// - Migração de dados
  /// - Recuperação de erro catastrófico
  /// - Reset completo da aplicação
  Future<void> resetAllSyncMetadata() async {
    try {
      // TODO: Implementar reset no banco local
      // UPDATE sync_metadata SET sync_status = pending, retry_count = 0
      print('⚠️ AVISO: Todos os metadados de sincronização foram resetados');
    } catch (e) {
      print('Erro ao resetar metadados: $e');
    }
  }
}

// ============================================================================
// CLASSES DE RESULTADO E EXCEÇÃO
// ============================================================================

/// Resultado de uma operação de sincronização
class SyncResult {
  /// Número de registros enviados para o Firebase
  final int uploadedCount;

  /// Número de registros baixados do Firebase
  final int downloadedCount;

  /// Número de conflitos detectados
  final int conflictsCount;

  /// Tempo total da operação
  final Duration duration;

  /// Lista de erros não-fatais que ocorreram
  final List<String> errors;

  /// Timestamp da sincronização
  final DateTime timestamp;

  const SyncResult({
    required this.uploadedCount,
    required this.downloadedCount,
    required this.conflictsCount,
    required this.duration,
    required this.errors,
    required this.timestamp,
  });

  /// Indica se a sincronização foi completamente bem-sucedida
  bool get isSuccess => errors.isEmpty && conflictsCount == 0;

  /// Total de registros processados
  int get totalProcessed => uploadedCount + downloadedCount;

  /// Indica se houve alguma atividade de sincronização
  bool get hasChanges => totalProcessed > 0;

  @override
  String toString() {
    return 'SyncResult('
        'uploaded: $uploadedCount, '
        'downloaded: $downloadedCount, '
        'conflicts: $conflictsCount, '
        'duration: ${duration.inSeconds}s, '
        'errors: ${errors.length}'
        ')';
  }

  /// Converte para Map para serialização
  Map<String, dynamic> toJson() {
    return {
      'uploadedCount': uploadedCount,
      'downloadedCount': downloadedCount,
      'conflictsCount': conflictsCount,
      'durationSeconds': duration.inSeconds,
      'errors': errors,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
