Objetivo
Sincronizar dados entre dispositivo local (Drift) e Firebase (Firestore).
Estratégia: Offline-First
Princípios

Todas operações são primeiro locais
Sincronização em background
Resolução de conflitos: Last-Write-Wins
Soft-Deletes para propagar exclusões

Fluxo
Ação do Usuário
    ↓
Salva Local (Drift)
    ↓
Marca para Sync (pending)
    ↓
Background Sync → Firebase
    ↓
Atualiza Status (synced)
SyncViewModel
dartclass SyncViewModel extends StateNotifier<SyncState> {
  final FirebaseSyncService _syncService;

  Future<void> syncNow() async {
    state = state.copyWith(isSyncing: true);
    
    // 1. Push local changes to Firebase
    await _syncService.syncPendingChanges();
    
    // 2. Pull remote changes from Firebase
    await _syncService.syncFromFirebase();
    
    state = state.copyWith(isSyncing: false, lastSyncedAt: DateTime.now());
  }

  void startAutoSync() {
    Timer.periodic(Duration(minutes: 5), (_) async {
      if (await _hasConnection()) {
        await syncNow();
      }
    });
  }
}
Resolução de Conflitos
dart// Last-Write-Wins baseado em updatedAt
if (remote.updatedAt.isAfter(local.updatedAt)) {
  // Remote mais recente, atualiza local
  await dao.update(remote);
} else if (local.updatedAt.isAfter(remote.updatedAt)) {
  // Local mais recente, atualiza remote
  await firestore.update(local);
}

Desenvolvido por: Leankar.dev
Versão: 1.0.0
Contato: leankar.dev@gmail.com