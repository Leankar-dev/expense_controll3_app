/// Classe que contém todas as constantes globais do aplicativo.
abstract final class AppConstants {
  /// Nome do aplicativo
  static const String appName = 'Expense Control';

  /// Versão do aplicativo
  static const String appVersion = '1.0.0';

  /// Build number
  static const String buildNumber = '1';

  /// Nome do desenvolvedor
  static const String developerName = 'Leankar.dev';

  /// Email de suporte
  static const String supportEmail = 'leankar.dev@gmail.com';

  /// Website do desenvolvedor
  static const String developerWebsite = 'https://leankar.dev';

  /// Texto de branding completo
  static const String brandingText = 'Desenvolvido por $developerName';

  /// Locale do aplicativo
  static const String locale = 'pt_PT';

  /// Código do país
  static const String countryCode = 'PT';

  /// Código da língua
  static const String languageCode = 'pt';

  /// Símbolo da moeda
  static const String currencySymbol = '€';

  /// Código ISO da moeda
  static const String currencyCode = 'EUR';

  /// Formato de data
  static const String dateFormat = 'dd/MM/yyyy';

  /// Formato de data e hora
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

  /// Formato de hora
  static const String timeFormat = 'HH:mm';

  /// Comprimento mínimo da senha
  static const int passwordMinLength = 8;

  /// Comprimento mínimo da descrição
  static const int descriptionMinLength = 3;

  /// Comprimento máximo da descrição
  static const int descriptionMaxLength = 200;

  /// Comprimento mínimo do nome da categoria
  static const int categoryNameMinLength = 2;

  /// Comprimento máximo do nome da categoria
  static const int categoryNameMaxLength = 50;

  /// Valor máximo permitido para transação
  static const double maxTransactionAmount = 999999999.99;

  /// Valor mínimo permitido para transação
  static const double minTransactionAmount = 0.01;

  /// Anos máximos no passado para transações
  static const int maxYearsInPast = 10;

  /// Intervalo de sincronização automática (em minutos)
  static const int autoSyncIntervalMinutes = 5;

  /// Timeout de conexão (em segundos)
  static const int connectionTimeoutSeconds = 30;

  /// Número máximo de tentativas de sincronização
  static const int maxSyncRetries = 3;

  /// Delay entre tentativas de sincronização (em segundos)
  static const int syncRetryDelaySeconds = 5;

  /// Nome do banco de dados local
  static const String databaseName = 'expense_control.sqlite';

  /// Versão do schema do banco de dados
  static const int databaseVersion = 1;

  /// Chave para preferências de usuário
  static const String prefsKeyUser = 'user_prefs';

  /// Chave para última sincronização
  static const String prefsKeyLastSync = 'last_sync';

  /// Chave para configurações de notificação
  static const String prefsKeyNotifications = 'notifications';

  /// Chave para primeiro acesso
  static const String prefsKeyFirstAccess = 'first_access';

  /// ID do canal de notificações (Android)
  static const String notificationChannelId = 'expense_control_channel';

  /// Nome do canal de notificações
  static const String notificationChannelName = 'Expense Control';

  /// Descrição do canal de notificações
  static const String notificationChannelDescription =
      'Notificações do Expense Control';

  /// Hora do lembrete diário (20:00)
  static const int dailyReminderHour = 20;

  /// Minuto do lembrete diário
  static const int dailyReminderMinute = 0;

  /// ID da notificação de lembrete diário
  static const int dailyReminderNotificationId = 1;

  /// ID da notificação de limite excedido
  static const int limitExceededNotificationId = 2;

  /// ID da notificação de resumo mensal
  static const int monthlySummaryNotificationId = 3;

  /// Padding padrão horizontal
  static const double defaultPaddingHorizontal = 16.0;

  /// Padding padrão vertical
  static const double defaultPaddingVertical = 16.0;

  /// Espaçamento pequeno
  static const double spacingSmall = 8.0;

  /// Espaçamento médio
  static const double spacingMedium = 16.0;

  /// Espaçamento grande
  static const double spacingLarge = 24.0;

  /// Espaçamento extra grande
  static const double spacingXLarge = 32.0;

  /// Border radius pequeno
  static const double borderRadiusSmall = 8.0;

  /// Border radius médio
  static const double borderRadiusMedium = 12.0;

  /// Border radius grande
  static const double borderRadiusLarge = 16.0;

  /// Border radius extra grande
  static const double borderRadiusXLarge = 20.0;

  /// Largura máxima para responsividade (mobile)
  static const double maxWidthMobile = 600.0;

  /// Largura máxima para responsividade (tablet)
  static const double maxWidthTablet = 900.0;

  /// Altura do AppBar
  static const double appBarHeight = 56.0;

  /// Altura do Bottom Navigation Bar
  static const double bottomNavBarHeight = 80.0;

  /// Duração de animação rápida (ms)
  static const int animationDurationFast = 200;

  /// Duração de animação padrão (ms)
  static const int animationDurationDefault = 300;

  /// Duração de animação de rota (ms)
  static const int animationDurationRoute = 500;

  /// Duração de animação lenta (ms)
  static const int animationDurationSlow = 600;

  /// Duração da splash screen (ms)
  static const int splashDuration = 2000;

  /// Delay para debounce de busca (ms)
  static const int searchDebounceDelay = 500;

  /// Número de itens por página
  static const int itemsPerPage = 20;

  /// Threshold para carregar mais itens (scroll)
  static const double loadMoreThreshold = 200.0;

  /// Percentagem de alerta de limite (80%)
  static const double limitWarningPercentage = 0.80;

  /// Percentagem de perigo de limite (95%)
  static const double limitDangerPercentage = 0.95;

  /// Lista de categorias padrão
  static const List<DefaultCategory> defaultCategories = [
    DefaultCategory(
      name: 'Alimentação',
      icon: '🍔',
      color: '#FF5733',
    ),
    DefaultCategory(
      name: 'Transporte',
      icon: '🚗',
      color: '#3498DB',
    ),
    DefaultCategory(
      name: 'Saúde',
      icon: '💊',
      color: '#2ECC71',
    ),
    DefaultCategory(
      name: 'Lazer',
      icon: '🎮',
      color: '#9B59B6',
    ),
    DefaultCategory(
      name: 'Outros',
      icon: '📦',
      color: '#95A5A6',
    ),
  ];

  /// Lista de métodos de pagamento disponíveis
  static const List<String> paymentMethods = [
    'Cartão de Crédito',
    'Cartão de Débito',
    'MBWay',
    'PIX',
    'Dinheiro',
  ];

  /// Extensão de arquivo Excel
  static const String excelExtension = '.xlsx';

  /// Extensão de arquivo CSV
  static const String csvExtension = '.csv';

  /// Extensão de arquivo PDF
  static const String pdfExtension = '.pdf';

  /// Delimitador CSV
  static const String csvDelimiter = ';';

  /// Prefixo do nome do arquivo de exportação
  static const String exportFilePrefix = 'expense_control_';

  /// Padrão de email
  static const String emailPattern =
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$';

  /// Padrão de cor hexadecimal
  static const String hexColorPattern = r'^#?([A-Fa-f0-9]{6})$';

  /// Mensagem de erro genérica
  static const String genericErrorMessage =
      'Ocorreu um erro inesperado. Tente novamente.';

  /// Mensagem de sem conexão
  static const String noConnectionMessage =
      'Sem ligação à internet. Verifique a sua conexão.';

  /// Mensagem de sucesso ao guardar
  static const String saveSuccessMessage = 'Guardado com sucesso!';

  /// Mensagem de sucesso ao eliminar
  static const String deleteSuccessMessage = 'Eliminado com sucesso!';

  /// Mensagem de confirmação de eliminação
  static const String deleteConfirmationMessage =
      'Tem a certeza que deseja eliminar?';

  /// Mensagem de sessão expirada
  static const String sessionExpiredMessage =
      'A sua sessão expirou. Faça login novamente.';
}

/// Classe para representar uma categoria padrão
class DefaultCategory {
  final String name;
  final String icon;
  final String color;

  const DefaultCategory({
    required this.name,
    required this.icon,
    required this.color,
  });
}
