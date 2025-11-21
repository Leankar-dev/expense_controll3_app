import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Classe que contém todos os estilos de texto utilizados no aplicativo.
/// Segue as diretrizes de tipografia Material Design 3.
abstract final class TextStyles {
  // ============================================================
  // FAMÍLIA DE FONTE
  // ============================================================

  /// Fonte principal do aplicativo
  static const String fontFamily = 'Roboto';

  // ============================================================
  // DISPLAY (Títulos Grandes)
  // ============================================================

  /// Display Large - 57sp
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
    color: AppColors.textPrimary,
  );

  /// Display Medium - 45sp
  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.16,
    color: AppColors.textPrimary,
  );

  /// Display Small - 36sp
  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.22,
    color: AppColors.textPrimary,
  );

  // ============================================================
  // HEADLINE (Títulos de Seção)
  // ============================================================

  /// Headline Large - 32sp
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  /// Headline Medium - 28sp
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.29,
    color: AppColors.textPrimary,
  );

  /// Headline Small - 24sp
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.33,
    color: AppColors.textPrimary,
  );

  // ============================================================
  // TITLE (Títulos de Componentes)
  // ============================================================

  /// Title Large - 22sp
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.27,
    color: AppColors.textPrimary,
  );

  /// Title Medium - 16sp
  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.50,
    color: AppColors.textPrimary,
  );

  /// Title Small - 14sp
  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
    color: AppColors.textPrimary,
  );

  // ============================================================
  // BODY (Texto do Corpo)
  // ============================================================

  /// Body Large - 16sp
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.50,
    color: AppColors.textPrimary,
  );

  /// Body Medium - 14sp (Padrão para texto)
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    color: AppColors.textPrimary,
  );

  /// Body Small - 12sp
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: AppColors.textSecondary,
  );

  // ============================================================
  // LABEL (Rótulos e Botões)
  // ============================================================

  /// Label Large - 14sp (Botões)
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
    color: AppColors.textPrimary,
  );

  /// Label Medium - 12sp
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.33,
    color: AppColors.textPrimary,
  );

  /// Label Small - 11sp
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.45,
    color: AppColors.textSecondary,
  );

  // ============================================================
  // ESTILOS CUSTOMIZADOS - VALORES MONETÁRIOS
  // ============================================================

  /// Valor monetário grande (saldo principal)
  static const TextStyle currencyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  /// Valor monetário médio (cards)
  static const TextStyle currencyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  /// Valor monetário pequeno (listas)
  static const TextStyle currencySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  /// Valor de receita (verde)
  static const TextStyle incomeValue = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
    color: AppColors.income,
  );

  /// Valor de despesa (vermelho)
  static const TextStyle expenseValue = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
    color: AppColors.expense,
  );

  // ============================================================
  // ESTILOS CUSTOMIZADOS - FORMULÁRIOS
  // ============================================================

  /// Label de campo de formulário
  static const TextStyle inputLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  /// Texto de input
  static const TextStyle inputText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  /// Hint/Placeholder de input
  static const TextStyle inputHint = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
    color: AppColors.textTertiary,
  );

  /// Texto de erro em formulários
  static const TextStyle inputError = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.3,
    color: AppColors.error,
  );

  // ============================================================
  // ESTILOS CUSTOMIZADOS - BOTÕES
  // ============================================================

  /// Texto de botão primário
  static const TextStyle buttonPrimary = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.4,
    color: AppColors.textOnPrimary,
  );

  /// Texto de botão secundário
  static const TextStyle buttonSecondary = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.4,
    color: AppColors.primary,
  );

  /// Texto de link/text button
  static const TextStyle link = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.25,
    height: 1.4,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );

  // ============================================================
  // ESTILOS CUSTOMIZADOS - CARDS E LISTAS
  // ============================================================

  /// Título de card
  static const TextStyle cardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  /// Subtítulo de card
  static const TextStyle cardSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  /// Descrição de item de lista
  static const TextStyle listItemDescription = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.3,
    color: AppColors.textTertiary,
  );

  // ============================================================
  // ESTILOS CUSTOMIZADOS - BADGES E CHIPS
  // ============================================================

  /// Texto de badge/chip
  static const TextStyle badge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.2,
    color: AppColors.textOnPrimary,
  );

  /// Texto de categoria
  static const TextStyle category = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
    height: 1.3,
    color: AppColors.textSecondary,
  );

  // ============================================================
  // ESTILOS CUSTOMIZADOS - APP BAR
  // ============================================================

  /// Título da AppBar
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // ============================================================
  // ESTILOS CUSTOMIZADOS - SPLASH/BRANDING
  // ============================================================

  /// Título do app (Splash Screen)
  static const TextStyle appTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
    color: AppColors.primary,
  );

  /// Subtítulo/Branding (by Leankar.dev)
  static const TextStyle branding = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.4,
    color: AppColors.textTertiary,
  );

  // ============================================================
  // MÉTODOS UTILITÁRIOS
  // ============================================================

  /// Retorna o estilo de valor baseado no tipo de transação
  static TextStyle getValueStyle({required bool isIncome, double? fontSize}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize ?? 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.4,
      color: isIncome ? AppColors.income : AppColors.expense,
    );
  }

  /// Cria um estilo com cor customizada
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Cria um estilo com peso customizado
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  /// Cria um estilo com tamanho customizado
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }
}
