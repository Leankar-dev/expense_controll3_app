import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'app_colors.dart';
import 'text_styles.dart';

/// Classe que contém todas as configurações de tema do aplicativo.
abstract final class AppTheme {
  // ============================================================
  // CONFIGURAÇÕES NEUMORPHIC
  // ============================================================

  /// Tema Neumorphic padrão
  static NeumorphicThemeData get neumorphicTheme => const NeumorphicThemeData(
    baseColor: AppColors.background,
    lightSource: LightSource.topLeft,
    depth: 6,
    intensity: 0.5,
    shadowLightColor: AppColors.neumorphicLight,
    shadowDarkColor: AppColors.neumorphicDark,
  );

  /// Estilo Neumorphic para cards (convexo)
  static NeumorphicStyle get cardStyle => NeumorphicStyle(
    shape: NeumorphicShape.flat,
    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
    depth: 4,
    intensity: 0.5,
    lightSource: LightSource.topLeft,
    color: AppColors.background,
    shadowLightColor: AppColors.neumorphicLight,
    shadowDarkColor: AppColors.neumorphicDark,
  );

  /// Estilo Neumorphic para botões (convexo)
  static NeumorphicStyle get buttonStyle => NeumorphicStyle(
    shape: NeumorphicShape.convex,
    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
    depth: 4,
    intensity: 0.6,
    lightSource: LightSource.topLeft,
    color: AppColors.primary,
    shadowLightColor: AppColors.neumorphicLight,
    shadowDarkColor: AppColors.neumorphicDark,
  );

  /// Estilo Neumorphic para campos de texto (côncavo/pressed)
  static NeumorphicStyle get inputStyle => NeumorphicStyle(
    shape: NeumorphicShape.concave,
    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
    depth: -3,
    intensity: 0.5,
    lightSource: LightSource.topLeft,
    color: AppColors.background,
    shadowLightColor: AppColors.neumorphicLight,
    shadowDarkColor: AppColors.neumorphicDark,
  );

  /// Estilo Neumorphic para containers
  static NeumorphicStyle get containerStyle => NeumorphicStyle(
    shape: NeumorphicShape.flat,
    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
    depth: 6,
    intensity: 0.5,
    lightSource: LightSource.topLeft,
    color: AppColors.background,
    shadowLightColor: AppColors.neumorphicLight,
    shadowDarkColor: AppColors.neumorphicDark,
  );

  /// Estilo Neumorphic para chips/badges
  static NeumorphicStyle get chipStyle => NeumorphicStyle(
    shape: NeumorphicShape.flat,
    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
    depth: 2,
    intensity: 0.4,
    lightSource: LightSource.topLeft,
    color: AppColors.background,
    shadowLightColor: AppColors.neumorphicLight,
    shadowDarkColor: AppColors.neumorphicDark,
  );

  /// Estilo Neumorphic para ícones circulares
  static NeumorphicStyle get circleStyle => const NeumorphicStyle(
    shape: NeumorphicShape.flat,
    boxShape: NeumorphicBoxShape.circle(),
    depth: 4,
    intensity: 0.5,
    lightSource: LightSource.topLeft,
    color: AppColors.background,
    shadowLightColor: AppColors.neumorphicLight,
    shadowDarkColor: AppColors.neumorphicDark,
  );

  // ============================================================
  // TEMA MATERIAL (LIGHT)
  // ============================================================

  /// Tema claro principal do aplicativo
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Cores
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.primaryDark,
      secondary: AppColors.secondary,
      onSecondary: AppColors.textOnDark,
      secondaryContainer: AppColors.secondaryLight,
      onSecondaryContainer: AppColors.secondaryDark,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
      onError: AppColors.textOnDark,
      errorContainer: AppColors.errorLight,
      outline: AppColors.border,
      outlineVariant: AppColors.divider,
    ),

    // Scaffold
    scaffoldBackgroundColor: AppColors.background,

    // AppBar
    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      centerTitle: true,
      titleTextStyle: TextStyles.appBarTitle,
      iconTheme: IconThemeData(
        color: AppColors.textPrimary,
        size: 24,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),

    // Tipografia
    textTheme: const TextTheme(
      displayLarge: TextStyles.displayLarge,
      displayMedium: TextStyles.displayMedium,
      displaySmall: TextStyles.displaySmall,
      headlineLarge: TextStyles.headlineLarge,
      headlineMedium: TextStyles.headlineMedium,
      headlineSmall: TextStyles.headlineSmall,
      titleLarge: TextStyles.titleLarge,
      titleMedium: TextStyles.titleMedium,
      titleSmall: TextStyles.titleSmall,
      bodyLarge: TextStyles.bodyLarge,
      bodyMedium: TextStyles.bodyMedium,
      bodySmall: TextStyles.bodySmall,
      labelLarge: TextStyles.labelLarge,
      labelMedium: TextStyles.labelMedium,
      labelSmall: TextStyles.labelSmall,
    ),

    // Botões
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyles.buttonPrimary,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        textStyle: TextStyles.buttonSecondary,
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: TextStyles.link.copyWith(decoration: TextDecoration.none),
      ),
    ),

    // Floating Action Button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      elevation: 4,
      shape: CircleBorder(),
    ),

    // Cards
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      labelStyle: TextStyles.inputLabel,
      hintStyle: TextStyles.inputHint,
      errorStyle: TextStyles.inputError,
      prefixIconColor: AppColors.icon,
      suffixIconColor: AppColors.icon,
    ),

    // Chips
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.background,
      selectedColor: AppColors.primaryLight,
      disabledColor: AppColors.divider,
      labelStyle: TextStyles.category,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.icon,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyles.labelSmall,
      unselectedLabelStyle: TextStyles.labelSmall,
    ),

    // Navigation Bar (Material 3)
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.background,
      indicatorColor: AppColors.primaryLight,
      elevation: 0,
      height: 80,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyles.labelSmall.copyWith(color: AppColors.primary);
        }
        return TextStyles.labelSmall.copyWith(color: AppColors.icon);
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.primary, size: 24);
        }
        return const IconThemeData(color: AppColors.icon, size: 24);
      }),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),

    // Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titleTextStyle: TextStyles.titleLarge,
      contentTextStyle: TextStyles.bodyMedium,
    ),

    // Bottom Sheet
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      dragHandleColor: AppColors.divider,
      dragHandleSize: Size(40, 4),
      showDragHandle: true,
    ),

    // Snackbar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.textPrimary,
      contentTextStyle: TextStyles.bodyMedium.copyWith(
        color: AppColors.textOnDark,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 4,
    ),

    // Progress Indicator
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.divider,
      circularTrackColor: AppColors.divider,
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: AppColors.icon,
      size: 24,
    ),

    // List Tile
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      iconColor: AppColors.icon,
      textColor: AppColors.textPrimary,
      subtitleTextStyle: TextStyles.bodySmall,
      titleTextStyle: TextStyles.titleMedium,
    ),

    // Switch
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.icon;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryLight;
        }
        return AppColors.divider;
      }),
    ),

    // Checkbox
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColors.textOnPrimary),
      side: const BorderSide(color: AppColors.border, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),

    // Radio
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.border;
      }),
    ),

    // Date Picker
    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.surface,
      headerBackgroundColor: AppColors.primary,
      headerForegroundColor: AppColors.textOnPrimary,
      dayStyle: TextStyles.bodyMedium,
      todayBorder: const BorderSide(color: AppColors.primary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    // Time Picker
    timePickerTheme: TimePickerThemeData(
      backgroundColor: AppColors.surface,
      dialBackgroundColor: AppColors.background,
      hourMinuteColor: AppColors.primaryLight,
      dayPeriodColor: AppColors.primaryLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );

  // ============================================================
  // CONSTANTES DE LAYOUT
  // ============================================================

  /// Padding padrão horizontal
  static const double paddingHorizontal = 16.0;

  /// Padding padrão vertical
  static const double paddingVertical = 16.0;

  /// Padding padrão para telas
  static const EdgeInsets screenPadding = EdgeInsets.all(16.0);

  /// Espaçamento pequeno
  static const double spacingSmall = 8.0;

  /// Espaçamento médio
  static const double spacingMedium = 16.0;

  /// Espaçamento grande
  static const double spacingLarge = 24.0;

  /// Espaçamento extra grande
  static const double spacingXLarge = 32.0;

  /// Border radius pequeno
  static const double radiusSmall = 8.0;

  /// Border radius médio
  static const double radiusMedium = 12.0;

  /// Border radius grande
  static const double radiusLarge = 16.0;

  /// Border radius extra grande
  static const double radiusXLarge = 20.0;

  /// Border radius circular
  static const double radiusCircular = 100.0;

  // ============================================================
  // DURAÇÕES DE ANIMAÇÃO
  // ============================================================

  /// Duração de animação rápida
  static const Duration animationFast = Duration(milliseconds: 200);

  /// Duração de animação padrão
  static const Duration animationDefault = Duration(milliseconds: 300);

  /// Duração de animação de transição de rota
  static const Duration animationRoute = Duration(milliseconds: 500);

  /// Duração de animação lenta
  static const Duration animationSlow = Duration(milliseconds: 600);

  /// Duração da Splash Screen
  static const Duration splashDuration = Duration(milliseconds: 2000);

  /// Curva de animação padrão
  static const Curve animationCurve = Curves.easeInOutCubic;

  // ============================================================
  // MÉTODOS UTILITÁRIOS
  // ============================================================

  /// Retorna o estilo Neumorphic com profundidade customizada
  static NeumorphicStyle getNeumorphicStyle({
    double depth = 4,
    double intensity = 0.5,
    NeumorphicShape shape = NeumorphicShape.flat,
    NeumorphicBoxShape? boxShape,
    Color? color,
  }) {
    return NeumorphicStyle(
      shape: shape,
      boxShape:
          boxShape ?? NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
      depth: depth,
      intensity: intensity,
      lightSource: LightSource.topLeft,
      color: color ?? AppColors.background,
      shadowLightColor: AppColors.neumorphicLight,
      shadowDarkColor: AppColors.neumorphicDark,
    );
  }

  /// Retorna o estilo Neumorphic para estado pressionado
  static NeumorphicStyle getPressedStyle(NeumorphicStyle baseStyle) {
    return baseStyle.copyWith(
      depth: -baseStyle.depth!.abs(),
      shape: NeumorphicShape.concave,
    );
  }
}
