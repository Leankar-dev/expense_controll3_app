# 📊 DOCS/features/dashboard_analytics.md

## Objetivo
Visualizar métricas financeiras e gráficos interativos para análise de receitas, despesas e evolução do saldo.

## Funcionalidades
- Saldo atual em tempo real
- Totalizadores de receitas e despesas
- Gráfico de pizza (distribuição por categoria)
- Gráfico de barras (receitas vs despesas)
- Gráfico de linhas (evolução do saldo)

## Implementação com fl_chart

### DashboardViewModel
```dart
class DashboardViewModel extends StateNotifier<DashboardState> {
  final CalculateBalanceUseCase _calculateBalanceUseCase;
  final GetCategoryDistributionUseCase _getCategoryDistributionUseCase;

  Future<void> loadDashboardData() async {
    // Carrega saldo, distribuição de categorias, etc.
  }
}
```

### Gráficos
- **PieChart:** Percentual por categoria
- **BarChart:** Comparação semanal/mensal
- **LineChart:** Evolução temporal do saldo

---

# 📄 DOCS/features/reports_export.md

## Objetivo
Gerar e compartilhar relatórios financeiros em múltiplos formatos.

## Formatos Suportados
- ✅ Excel (syncfusion_flutter_xlsio)
- ✅ CSV
- ✅ PDF

## Funcionalidades
- Relatório mensal detalhado
- Análise por categoria
- Resumo anual
- Extrato customizado por período

## Compartilhamento
- WhatsApp
- Email
- Compartilhamento nativo (share_plus)

### ExportViewModel
```dart
class ExportViewModel extends StateNotifier<ExportState> {
  final ExportToExcelUseCase _exportToExcelUseCase;
  final ShareReportUseCase _shareReportUseCase;

  Future<void> exportToExcel(List<Transaction> transactions) async {
    // Gera arquivo Excel e compartilha
  }
}
```

---

# 🔔 DOCS/features/notifications.md

## Objetivo
Engajar usuários com lembretes e alertas personalizados.

## Tipos de Notificações
- Lembretes diários para registrar gastos (20:00)
- Alertas de limite de categoria excedido
- Resumo mensal (primeiro dia do mês)
- Notificações de metas atingidas

## Implementação

### NotificationService
```dart
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;

  Future<void> scheduleDailyReminder() async {
    await _plugin.zonedSchedule(
      0,
      'Registar Gastos',
      'Não se esqueça de registar os gastos de hoje!',
      _nextInstanceOf20PM(),
      const NotificationDetails(...),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: ...,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> showCategoryLimitAlert(String category) async {
    await _plugin.show(
      1,
      'Limite Excedido',
      'Você ultrapassou o limite da categoria $category',
      const NotificationDetails(...),
    );
  }
}
```

## Permissões
Solicitadas no primeiro uso via diálogo explicativo.

---

# 🔄 DOCS/features/synchronization.md

## Objetivo
Sincronizar dados entre dispositivo local (Drift) e Firebase (Firestore).

## Estratégia: Offline-First

### Princípios
1. Todas operações são primeiro locais
2. Sincronização em background
3. Resolução de conflitos: Last-Write-Wins
4. Soft-Deletes para propagar exclusões

### Fluxo
```
Ação do Usuário
    ↓
Salva Local (Drift)
    ↓
Marca para Sync (pending)
    ↓
Background Sync → Firebase
    ↓
Atualiza Status (synced)
```

### SyncViewModel
```dart
class SyncViewModel extends StateNotifier<SyncState> {
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
```

### Resolução de Conflitos
```dart
// Last-Write-Wins baseado em updatedAt
if (remote.updatedAt.isAfter(local.updatedAt)) {
  // Remote mais recente, atualiza local
  await dao.update(remote);
} else if (local.updatedAt.isAfter(remote.updatedAt)) {
  // Local mais recente, atualiza remote
  await firestore.update(local);
}
```

---

**Desenvolvido por:** Leankar.dev  
**Versão:** 1.0.0  
**Contato:** leankar.dev@gmail.com