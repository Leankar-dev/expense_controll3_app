Objetivo
Engajar usuários com lembretes e alertas personalizados.
Tipos de Notificações

Lembretes diários para registrar gastos (20:00)
Alertas de limite de categoria excedido
Resumo mensal (primeiro dia do mês)
Notificações de metas atingidas

Implementação
NotificationService
dartclass NotificationService {
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
Permissões
Solicitadas no primeiro uso via diálogo explicativo.