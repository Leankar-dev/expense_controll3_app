import 'package:flutter/material.dart';

/// Classe que contém todas as cores utilizadas no aplicativo.
/// Paleta de cores para o tema Neumorphic do Expense Control APP.
abstract final class AppColors {
  // ============================================================
  // CORES PRIMÁRIAS
  // ============================================================

  /// Cor primária principal do app
  static const Color primary = Color(0xFF6C63FF);

  /// Variação clara da cor primária
  static const Color primaryLight = Color(0xFF9D97FF);

  /// Variação escura da cor primária
  static const Color primaryDark = Color(0xFF4A42CC);

  // ============================================================
  // CORES SECUNDÁRIAS
  // ============================================================

  /// Cor secundária/accent
  static const Color secondary = Color(0xFF03DAC6);

  /// Variação clara da cor secundária
  static const Color secondaryLight = Color(0xFF66FFF8);

  /// Variação escura da cor secundária
  static const Color secondaryDark = Color(0xFF00A896);

  // ============================================================
  // CORES DE FUNDO (NEUMORPHIC)
  // ============================================================

  /// Cor de fundo principal (Neumorphic base)
  static const Color background = Color(0xFFE8EEF1);

  /// Cor de fundo para cards e superfícies
  static const Color surface = Color(0xFFE8EEF1);

  /// Cor de fundo alternativa (mais clara)
  static const Color backgroundLight = Color(0xFFF5F7FA);

  /// Cor de fundo para elementos elevados
  static const Color backgroundElevated = Color(0xFFFFFFFF);

  // ============================================================
  // CORES NEUMORPHIC (SOMBRAS)
  // ============================================================

  /// Sombra clara (Neumorphic highlight)
  static const Color neumorphicLight = Color(0xFFFFFFFF);

  /// Sombra escura (Neumorphic shadow)
  static const Color neumorphicDark = Color(0xFFBEC8D1);

  /// Intensidade da sombra Neumorphic
  static const double neumorphicIntensity = 0.5;

  // ============================================================
  // CORES DE TEXTO
  // ============================================================

  /// Cor de texto primária (títulos, textos importantes)
  static const Color textPrimary = Color(0xFF2D3142);

  /// Cor de texto secundária (subtítulos, descrições)
  static const Color textSecondary = Color(0xFF6B7280);

  /// Cor de texto terciária (hints, placeholders)
  static const Color textTertiary = Color(0xFF9CA3AF);

  /// Cor de texto sobre fundo escuro
  static const Color textOnDark = Color(0xFFFFFFFF);

  /// Cor de texto sobre cor primária
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ============================================================
  // CORES DE TRANSAÇÃO
  // ============================================================

  /// Cor para receitas (income) - Verde
  static const Color income = Color(0xFF22C55E);

  /// Variação clara da cor de receita
  static const Color incomeLight = Color(0xFFDCFCE7);

  /// Variação escura da cor de receita
  static const Color incomeDark = Color(0xFF16A34A);

  /// Cor para despesas (expense) - Vermelho
  static const Color expense = Color(0xFFEF4444);

  /// Variação clara da cor de despesa
  static const Color expenseLight = Color(0xFFFEE2E2);

  /// Variação escura da cor de despesa
  static const Color expenseDark = Color(0xFFDC2626);

  // ============================================================
  // CORES DE CATEGORIAS
  // ============================================================

  /// Alimentação
  static const Color categoryFood = Color(0xFFFF5733);

  /// Transporte
  static const Color categoryTransport = Color(0xFF3498DB);

  /// Saúde
  static const Color categoryHealth = Color(0xFF2ECC71);

  /// Lazer
  static const Color categoryLeisure = Color(0xFF9B59B6);

  /// Outros
  static const Color categoryOthers = Color(0xFF95A5A6);

  /// Habitação
  static const Color categoryHousing = Color(0xFFE67E22);

  /// Educação
  static const Color categoryEducation = Color(0xFF1ABC9C);

  /// Compras
  static const Color categoryShopping = Color(0xFFE91E63);

  // ============================================================
  // CORES DE ESTADO
  // ============================================================

  /// Cor de sucesso
  static const Color success = Color(0xFF22C55E);

  /// Cor de sucesso clara (fundo)
  static const Color successLight = Color(0xFFDCFCE7);

  /// Cor de erro
  static const Color error = Color(0xFFEF4444);

  /// Cor de erro clara (fundo)
  static const Color errorLight = Color(0xFFFEE2E2);

  /// Cor de aviso/warning
  static const Color warning = Color(0xFFF59E0B);

  /// Cor de aviso clara (fundo)
  static const Color warningLight = Color(0xFFFEF3C7);

  /// Cor de informação
  static const Color info = Color(0xFF3B82F6);

  /// Cor de informação clara (fundo)
  static const Color infoLight = Color(0xFFDBEAFE);

  // ============================================================
  // CORES DE INTERFACE
  // ============================================================

  /// Cor de divisor/separador
  static const Color divider = Color(0xFFE5E7EB);

  /// Cor de borda
  static const Color border = Color(0xFFD1D5DB);

  /// Cor de borda focada
  static const Color borderFocused = Color(0xFF6C63FF);

  /// Cor de borda com erro
  static const Color borderError = Color(0xFFEF4444);

  /// Cor de ícone padrão
  static const Color icon = Color(0xFF6B7280);

  /// Cor de ícone ativo
  static const Color iconActive = Color(0xFF6C63FF);

  /// Cor de shimmer base
  static const Color shimmerBase = Color(0xFFE0E0E0);

  /// Cor de shimmer highlight
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // ============================================================
  // CORES DE GRÁFICOS
  // ============================================================

  /// Lista de cores para gráficos de pizza/barras
  static const List<Color> chartColors = [
    Color(0xFF6C63FF), // Primary
    Color(0xFF22C55E), // Green
    Color(0xFFEF4444), // Red
    Color(0xFFF59E0B), // Yellow
    Color(0xFF3B82F6), // Blue
    Color(0xFF8B5CF6), // Purple
    Color(0xFFEC4899), // Pink
    Color(0xFF14B8A6), // Teal
    Color(0xFFF97316), // Orange
    Color(0xFF6366F1), // Indigo
  ];

  // ============================================================
  // GRADIENTES
  // ============================================================

  /// Gradiente primário
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  /// Gradiente de receita
  static const LinearGradient incomeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [income, incomeDark],
  );

  /// Gradiente de despesa
  static const LinearGradient expenseGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [expense, expenseDark],
  );

  /// Gradiente de fundo
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundLight, background],
  );

  // ============================================================
  // MÉTODOS UTILITÁRIOS
  // ============================================================

  /// Retorna a cor de uma categoria pelo nome
  static Color getCategoryColor(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'alimentação':
        return categoryFood;
      case 'transporte':
        return categoryTransport;
      case 'saúde':
        return categoryHealth;
      case 'lazer':
        return categoryLeisure;
      case 'habitação':
        return categoryHousing;
      case 'educação':
        return categoryEducation;
      case 'compras':
        return categoryShopping;
      default:
        return categoryOthers;
    }
  }

  /// Retorna a cor baseada no tipo de transação
  static Color getTransactionColor(bool isIncome) {
    return isIncome ? income : expense;
  }

  /// Retorna a cor de fundo baseada no tipo de transação
  static Color getTransactionBackgroundColor(bool isIncome) {
    return isIncome ? incomeLight : expenseLight;
  }

  /// Converte uma string hexadecimal em Color
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Converte uma Color em string hexadecimal
  static String toHex(Color color) {
    final r = color.r.toInt().toRadixString(16).padLeft(2, '0');
    final g = color.g.toInt().toRadixString(16).padLeft(2, '0');
    final b = color.b.toInt().toRadixString(16).padLeft(2, '0');
    return '#${r.toUpperCase()}${g.toUpperCase()}${b.toUpperCase()}';
  }
}
