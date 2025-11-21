// import 'package:flutter/material.dart';

// import '../../presentation/views/splash/splash_screen.dart';
// import '../../presentation/views/auth/login_screen.dart';
// import '../../presentation/views/auth/register_screen.dart';
// import '../../presentation/views/auth/forgot_password_screen.dart';
// import '../../presentation/views/home/home_screen.dart';
// import '../../presentation/views/dashboard/dashboard_screen.dart';
// import '../../presentation/views/transactions/transactions_list_screen.dart';
// import '../../presentation/views/transactions/transaction_form_screen.dart';
// import '../../presentation/views/categories/categories_screen.dart';
// import '../../presentation/views/categories/category_form_screen.dart';
// import '../../presentation/views/reports/reports_screen.dart';
// import '../../presentation/views/reports/report_preview_screen.dart';
// import '../../presentation/views/settings/settings_screen.dart';
// import '../theme/app_theme.dart';

// /// Classe que contém todas as rotas nomeadas do aplicativo.
// abstract final class AppRoutes {
//   // ============================================================
//   // NOMES DAS ROTAS
//   // ============================================================

//   /// Rota inicial (Splash Screen)
//   static const String splash = '/';

//   /// Rota de login
//   static const String login = '/login';

//   /// Rota de registo
//   static const String register = '/register';

//   /// Rota de recuperação de senha
//   static const String forgotPassword = '/forgot-password';

//   /// Rota principal (Home com navegação)
//   static const String home = '/home';

//   /// Rota do dashboard
//   static const String dashboard = '/dashboard';

//   /// Rota da lista de transações
//   static const String transactions = '/transactions';

//   /// Rota do formulário de transação (criar)
//   static const String transactionForm = '/transaction/form';

//   /// Rota do formulário de transação (editar)
//   static const String transactionEdit = '/transaction/edit';

//   /// Rota da lista de categorias
//   static const String categories = '/categories';

//   /// Rota do formulário de categoria (criar)
//   static const String categoryForm = '/category/form';

//   /// Rota do formulário de categoria (editar)
//   static const String categoryEdit = '/category/edit';

//   /// Rota de relatórios
//   static const String reports = '/reports';

//   /// Rota de pré-visualização de relatório
//   static const String reportPreview = '/report/preview';

//   /// Rota de configurações
//   static const String settings = '/settings';

//   // ============================================================
//   // GERADOR DE ROTAS
//   // ============================================================

//   /// Gera as rotas com transições customizadas
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       // Splash
//       case splash:
//         return _buildRoute(
//           const SplashScreen(),
//           settings,
//           transitionType: _TransitionType.fade,
//         );

//       // Autenticação
//       case login:
//         return _buildRoute(
//           const LoginScreen(),
//           settings,
//           transitionType: _TransitionType.fade,
//         );

//       case register:
//         return _buildRoute(
//           const RegisterScreen(),
//           settings,
//         );

//       case forgotPassword:
//         return _buildRoute(
//           const ForgotPasswordScreen(),
//           settings,
//         );

//       // Home
//       case home:
//         return _buildRoute(
//           const HomeScreen(),
//           settings,
//           transitionType: _TransitionType.fade,
//         );

//       // Dashboard
//       case dashboard:
//         return _buildRoute(
//           const DashboardScreen(),
//           settings,
//         );

//       // Transações
//       case transactions:
//         return _buildRoute(
//           const TransactionsListScreen(),
//           settings,
//         );

//       case transactionForm:
//         return _buildRoute(
//           const TransactionFormScreen(),
//           settings,
//           transitionType: _TransitionType.slideUp,
//         );

//       case transactionEdit:
//         final args = settings.arguments as TransactionFormArguments?;
//         return _buildRoute(
//           TransactionFormScreen(transaction: args?.transaction),
//           settings,
//           transitionType: _TransitionType.slideUp,
//         );

//       // Categorias
//       case categories:
//         return _buildRoute(
//           const CategoriesScreen(),
//           settings,
//         );

//       case categoryForm:
//         return _buildRoute(
//           const CategoryFormScreen(),
//           settings,
//           transitionType: _TransitionType.slideUp,
//         );

//       case categoryEdit:
//         final args = settings.arguments as CategoryFormArguments?;
//         return _buildRoute(
//           CategoryFormScreen(category: args?.category),
//           settings,
//           transitionType: _TransitionType.slideUp,
//         );

//       // Relatórios
//       case reports:
//         return _buildRoute(
//           const ReportsScreen(),
//           settings,
//         );

//       case reportPreview:
//         final args = settings.arguments as ReportPreviewArguments?;
//         return _buildRoute(
//           ReportPreviewScreen(
//             reportType: args?.reportType ?? ReportType.monthly,
//             startDate: args?.startDate,
//             endDate: args?.endDate,
//           ),
//           settings,
//         );

//       // Configurações
//       case AppRoutes.settings:
//         return _buildRoute(
//           const SettingsScreen(),
//           settings,
//         );

//       // Rota não encontrada
//       default:
//         return _buildRoute(
//           const _NotFoundScreen(),
//           settings,
//         );
//     }
//   }

//   // ============================================================
//   // BUILDER DE ROTAS COM TRANSIÇÕES
//   // ============================================================

//   /// Constrói a rota com a transição especificada
//   static Route<dynamic> _buildRoute(
//     Widget page,
//     RouteSettings settings, {
//     _TransitionType transitionType = _TransitionType.slideRight,
//   }) {
//     return PageRouteBuilder(
//       settings: settings,
//       pageBuilder: (context, animation, secondaryAnimation) => page,
//       transitionDuration: AppTheme.animationRoute,
//       reverseTransitionDuration: AppTheme.animationRoute,
//       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         return switch (transitionType) {
//           _TransitionType.fade => _buildFadeTransition(animation, child),
//           _TransitionType.slideRight => _buildSlideRightTransition(
//             animation,
//             child,
//           ),
//           _TransitionType.slideLeft => _buildSlideLeftTransition(
//             animation,
//             child,
//           ),
//           _TransitionType.slideUp => _buildSlideUpTransition(animation, child),
//           _TransitionType.slideDown => _buildSlideDownTransition(
//             animation,
//             child,
//           ),
//           _TransitionType.scale => _buildScaleTransition(animation, child),
//         };
//       },
//     );
//   }

//   // ============================================================
//   // TRANSIÇÕES CUSTOMIZADAS
//   // ============================================================

//   /// Transição de fade (opacidade)
//   static Widget _buildFadeTransition(
//     Animation<double> animation,
//     Widget child,
//   ) {
//     return FadeTransition(
//       opacity: CurvedAnimation(
//         parent: animation,
//         curve: AppTheme.animationCurve,
//       ),
//       child: child,
//     );
//   }

//   /// Transição de slide da direita para esquerda
//   static Widget _buildSlideRightTransition(
//     Animation<double> animation,
//     Widget child,
//   ) {
//     final curvedAnimation = CurvedAnimation(
//       parent: animation,
//       curve: AppTheme.animationCurve,
//     );

//     return SlideTransition(
//       position: Tween<Offset>(
//         begin: const Offset(1.0, 0.0),
//         end: Offset.zero,
//       ).animate(curvedAnimation),
//       child: FadeTransition(
//         opacity: curvedAnimation,
//         child: child,
//       ),
//     );
//   }

//   /// Transição de slide da esquerda para direita
//   static Widget _buildSlideLeftTransition(
//     Animation<double> animation,
//     Widget child,
//   ) {
//     final curvedAnimation = CurvedAnimation(
//       parent: animation,
//       curve: AppTheme.animationCurve,
//     );

//     return SlideTransition(
//       position: Tween<Offset>(
//         begin: const Offset(-1.0, 0.0),
//         end: Offset.zero,
//       ).animate(curvedAnimation),
//       child: FadeTransition(
//         opacity: curvedAnimation,
//         child: child,
//       ),
//     );
//   }

//   /// Transição de slide de baixo para cima
//   static Widget _buildSlideUpTransition(
//     Animation<double> animation,
//     Widget child,
//   ) {
//     final curvedAnimation = CurvedAnimation(
//       parent: animation,
//       curve: AppTheme.animationCurve,
//     );

//     return SlideTransition(
//       position: Tween<Offset>(
//         begin: const Offset(0.0, 1.0),
//         end: Offset.zero,
//       ).animate(curvedAnimation),
//       child: FadeTransition(
//         opacity: curvedAnimation,
//         child: child,
//       ),
//     );
//   }

//   /// Transição de slide de cima para baixo
//   static Widget _buildSlideDownTransition(
//     Animation<double> animation,
//     Widget child,
//   ) {
//     final curvedAnimation = CurvedAnimation(
//       parent: animation,
//       curve: AppTheme.animationCurve,
//     );

//     return SlideTransition(
//       position: Tween<Offset>(
//         begin: const Offset(0.0, -1.0),
//         end: Offset.zero,
//       ).animate(curvedAnimation),
//       child: FadeTransition(
//         opacity: curvedAnimation,
//         child: child,
//       ),
//     );
//   }

//   /// Transição de escala
//   static Widget _buildScaleTransition(
//     Animation<double> animation,
//     Widget child,
//   ) {
//     final curvedAnimation = CurvedAnimation(
//       parent: animation,
//       curve: AppTheme.animationCurve,
//     );

//     return ScaleTransition(
//       scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
//       child: FadeTransition(
//         opacity: curvedAnimation,
//         child: child,
//       ),
//     );
//   }
// }

// // ============================================================
// // TIPOS DE TRANSIÇÃO
// // ============================================================

// /// Enum para tipos de transição de rota
// enum _TransitionType {
//   fade,
//   slideRight,
//   slideLeft,
//   slideUp,
//   slideDown,
//   scale,
// }

// // ============================================================
// // ARGUMENTOS DE NAVEGAÇÃO
// // ============================================================

// /// Argumentos para o formulário de transação
// class TransactionFormArguments {
//   final dynamic transaction;

//   const TransactionFormArguments({this.transaction});
// }

// /// Argumentos para o formulário de categoria
// class CategoryFormArguments {
//   final dynamic category;

//   const CategoryFormArguments({this.category});
// }

// /// Argumentos para pré-visualização de relatório
// class ReportPreviewArguments {
//   final ReportType reportType;
//   final DateTime? startDate;
//   final DateTime? endDate;

//   const ReportPreviewArguments({
//     required this.reportType,
//     this.startDate,
//     this.endDate,
//   });
// }

// /// Tipos de relatório disponíveis
// enum ReportType {
//   monthly,
//   yearly,
//   category,
//   custom,
// }

// // ============================================================
// // TELA DE ROTA NÃO ENCONTRADA
// // ============================================================

// class _NotFoundScreen extends StatelessWidget {
//   const _NotFoundScreen();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Página não encontrada'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.error_outline,
//               size: 64,
//               color: Colors.grey,
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Página não encontrada',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'A página que procura não existe.',
//               style: TextStyle(
//                 color: Colors.grey,
//               ),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pushNamedAndRemoveUntil(
//                   AppRoutes.home,
//                   (route) => false,
//                 );
//               },
//               child: const Text('Voltar ao início'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ============================================================
// // EXTENSÕES DE NAVEGAÇÃO
// // ============================================================

// /// Extensão para facilitar navegação
// extension NavigatorExtension on BuildContext {
//   /// Navega para uma rota
//   Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
//     return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
//   }

//   /// Navega e substitui a rota atual
//   Future<T?> pushReplacementNamed<T>(String routeName, {Object? arguments}) {
//     return Navigator.of(this).pushReplacementNamed<T, dynamic>(
//       routeName,
//       arguments: arguments,
//     );
//   }

//   /// Navega e remove todas as rotas anteriores
//   Future<T?> pushNamedAndRemoveUntil<T>(
//     String routeName, {
//     Object? arguments,
//   }) {
//     return Navigator.of(this).pushNamedAndRemoveUntil<T>(
//       routeName,
//       (route) => false,
//       arguments: arguments,
//     );
//   }

//   /// Volta para a rota anterior
//   void pop<T>([T? result]) {
//     Navigator.of(this).pop<T>(result);
//   }

//   /// Verifica se pode voltar
//   bool canPop() {
//     return Navigator.of(this).canPop();
//   }

//   /// Volta até uma rota específica
//   void popUntil(String routeName) {
//     Navigator.of(this).popUntil(ModalRoute.withName(routeName));
//   }
// }
