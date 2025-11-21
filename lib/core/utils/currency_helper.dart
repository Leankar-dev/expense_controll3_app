import 'dart:math' as math;

/// Classe utilitária para operações com valores monetários.
/// Localização: EUR (Euro) - Portugal
abstract final class CurrencyHelper {
  /// Símbolo da moeda
  static const String symbol = '€';

  /// Código ISO da moeda
  static const String code = 'EUR';

  /// Número de casas decimais
  static const int decimalPlaces = 2;

  /// Separador decimal (padrão PT)
  static const String decimalSeparator = ',';

  /// Separador de milhar (padrão PT)
  static const String thousandSeparator = '.';

  /// Converte string para double
  /// Aceita formatos: "1234.56", "1234,56", "1.234,56", "€ 1.234,56"
  static double? parse(String value) {
    if (value.trim().isEmpty) return null;

    try {
      // Remove símbolo da moeda, espaços e sinais
      var cleanValue = value
          .replaceAll(symbol, '')
          .replaceAll(code, '')
          .replaceAll(' ', '')
          .replaceAll('+', '')
          .trim();

      // Detecta se é formato PT (1.234,56) ou EN (1,234.56)
      final hasCommaAsDecimal =
          cleanValue.contains(',') &&
          (cleanValue.lastIndexOf(',') > cleanValue.lastIndexOf('.') ||
              !cleanValue.contains('.'));

      if (hasCommaAsDecimal) {
        // Formato PT: 1.234,56 -> 1234.56
        cleanValue = cleanValue.replaceAll('.', '').replaceAll(',', '.');
      } else {
        // Formato EN: 1,234.56 -> 1234.56
        cleanValue = cleanValue.replaceAll(',', '');
      }

      return double.tryParse(cleanValue);
    } catch (_) {
      return null;
    }
  }

  /// Converte double para string formatada (sem símbolo)
  /// Exemplo: 1234.56 -> "1.234,56"
  static String format(double value, {int? decimals}) {
    final places = decimals ?? decimalPlaces;
    final fixed = value.toStringAsFixed(places);

    // Separa parte inteira e decimal
    final parts = fixed.split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '00';

    // Adiciona separador de milhar
    final formatted = _addThousandSeparator(integerPart);

    return '$formatted$decimalSeparator$decimalPart';
  }

  /// Converte double para string formatada com símbolo
  /// Exemplo: 1234.56 -> "€ 1.234,56"
  static String formatWithSymbol(double value, {int? decimals}) {
    return '$symbol ${format(value, decimals: decimals)}';
  }

  /// Formata com sinal (+ ou -)
  /// Exemplo: 1234.56 -> "+€ 1.234,56"
  static String formatWithSign(double value, {int? decimals}) {
    final formatted = formatWithSymbol(value.abs(), decimals: decimals);
    if (value > 0) {
      return '+$formatted';
    } else if (value < 0) {
      return '-$formatted';
    }
    return formatted;
  }

  /// Formata para exibição compacta
  /// Exemplo: 1234567 -> "€ 1,23M"
  static String formatCompact(double value) {
    if (value.abs() >= 1000000000) {
      return '$symbol ${(value / 1000000000).toStringAsFixed(2)}B';
    } else if (value.abs() >= 1000000) {
      return '$symbol ${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value.abs() >= 1000) {
      return '$symbol ${(value / 1000).toStringAsFixed(2)}K';
    }
    return formatWithSymbol(value);
  }

  /// Adiciona separador de milhar
  static String _addThousandSeparator(String value) {
    final isNegative = value.startsWith('-');
    var digits = isNegative ? value.substring(1) : value;

    final buffer = StringBuffer();
    var count = 0;

    for (var i = digits.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        buffer.write(thousandSeparator);
      }
      buffer.write(digits[i]);
      count++;
    }

    final result = buffer.toString().split('').reversed.join();
    return isNegative ? '-$result' : result;
  }

  /// Arredonda para 2 casas decimais (padrão monetário)
  static double round(double value) {
    return (value * 100).round() / 100;
  }

  /// Arredonda para cima
  static double roundUp(double value, {int decimals = 2}) {
    final mod = math.pow(10, decimals);
    return (value * mod).ceil() / mod;
  }

  /// Arredonda para baixo
  static double roundDown(double value, {int decimals = 2}) {
    final mod = math.pow(10, decimals);
    return (value * mod).floor() / mod;
  }

  /// Calcula percentagem
  /// Exemplo: percentage(50, 200) = 25.0 (50 é 25% de 200)
  static double percentage(double value, double total) {
    if (total == 0) return 0;
    return (value / total) * 100;
  }

  /// Calcula valor a partir de percentagem
  /// Exemplo: fromPercentage(25, 200) = 50.0 (25% de 200)
  static double fromPercentage(double percent, double total) {
    return (percent / 100) * total;
  }

  /// Soma lista de valores
  static double sum(List<double> values) {
    if (values.isEmpty) return 0;
    return round(values.fold(0.0, (sum, value) => sum + value));
  }

  /// Calcula média
  static double average(List<double> values) {
    if (values.isEmpty) return 0;
    return round(sum(values) / values.length);
  }

  /// Encontra valor mínimo
  static double min(List<double> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a < b ? a : b);
  }

  /// Encontra valor máximo
  static double max(List<double> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a > b ? a : b);
  }

  /// Calcula diferença entre dois valores
  static double difference(double value1, double value2) {
    return round(value1 - value2);
  }

  /// Calcula variação percentual entre dois valores
  /// Exemplo: variation(110, 100) = 10.0 (aumento de 10%)
  static double variation(double newValue, double oldValue) {
    if (oldValue == 0) return newValue > 0 ? 100 : -100;
    return round(((newValue - oldValue) / oldValue.abs()) * 100);
  }

  /// Verifica se o valor é positivo
  static bool isPositive(double value) => value > 0;

  /// Verifica se o valor é negativo
  static bool isNegative(double value) => value < 0;

  /// Verifica se o valor é zero
  static bool isZero(double value) => value == 0;

  /// Verifica se o valor está dentro de um limite
  static bool isWithinLimit(double value, double limit) {
    return value <= limit;
  }

  /// Verifica se excede o limite
  static bool exceedsLimit(double value, double limit) {
    return value > limit;
  }

  /// Calcula quanto falta para atingir um limite
  static double remainingToLimit(double value, double limit) {
    final remaining = limit - value;
    return remaining > 0 ? round(remaining) : 0;
  }

  /// Calcula quanto excedeu o limite
  static double exceededAmount(double value, double limit) {
    final exceeded = value - limit;
    return exceeded > 0 ? round(exceeded) : 0;
  }

  /// Calcula saldo (receitas - despesas)
  static double calculateBalance({
    required double incomes,
    required double expenses,
  }) {
    return round(incomes - expenses);
  }

  /// Calcula saldo acumulado a partir de lista de transações
  /// Retorna lista com saldo acumulado em cada posição
  static List<double> cumulativeBalance(List<double> values) {
    if (values.isEmpty) return [];

    final cumulative = <double>[];
    var sum = 0.0;

    for (final value in values) {
      sum += value;
      cumulative.add(round(sum));
    }

    return cumulative;
  }

  /// Agrupa valores por categoria e soma
  static Map<String, double> groupAndSum(
    List<({String category, double value})> items,
  ) {
    final grouped = <String, double>{};

    for (final item in items) {
      grouped[item.category] = (grouped[item.category] ?? 0) + item.value;
    }

    // Arredonda todos os valores
    return grouped.map((key, value) => MapEntry(key, round(value)));
  }

  /// Calcula distribuição percentual por categoria
  static Map<String, double> distributionPercentage(
    Map<String, double> values,
  ) {
    final total = values.values.fold(0.0, (sum, v) => sum + v.abs());
    if (total == 0) return {};

    return values.map(
      (key, value) => MapEntry(key, round((value.abs() / total) * 100)),
    );
  }

  /// Formata valor para eixo Y de gráfico
  /// Exemplo: 1500 -> "1.5K", 2000000 -> "2M"
  static String formatAxisLabel(double value) {
    if (value.abs() >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value.abs() >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }

  /// Calcula intervalos para eixo Y de gráfico
  static List<double> calculateAxisIntervals(double maxValue, {int steps = 5}) {
    if (maxValue <= 0) return [0];

    // Encontra ordem de magnitude
    final magnitude = math.pow(10, (math.log(maxValue) / math.ln10).floor());
    final normalizedMax = maxValue / magnitude;

    // Arredonda para cima para um número "bonito"
    double niceMax;
    if (normalizedMax <= 1) {
      niceMax = 1;
    } else if (normalizedMax <= 2) {
      niceMax = 2;
    } else if (normalizedMax <= 5) {
      niceMax = 5;
    } else {
      niceMax = 10;
    }

    final roundedMax = niceMax * magnitude;
    final interval = roundedMax / steps;

    return List.generate(steps + 1, (i) => i * interval);
  }
}
