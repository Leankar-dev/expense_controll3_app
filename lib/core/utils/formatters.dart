import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Classe utilitária para formatação de valores.
/// Localização: Português (Portugal) - EUR
abstract final class Formatters {
  /// Locale para Portugal
  static const String locale = 'pt_PT';

  /// Símbolo da moeda
  static const String currencySymbol = '€';

  /// Código da moeda
  static const String currencyCode = 'EUR';

  /// Formatador de moeda padrão (€ 1.234,56)
  static final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: locale,
    symbol: '$currencySymbol ',
    decimalDigits: 2,
  );

  /// Formatador de moeda compacto (€ 1.2K)
  static final NumberFormat _currencyCompactFormatter =
      NumberFormat.compactCurrency(
        locale: locale,
        symbol: '$currencySymbol ',
        decimalDigits: 1,
      );

  /// Formatador de número simples (1.234,56)
  static final NumberFormat _numberFormatter = NumberFormat.decimalPattern(
    locale,
  );

  /// Formatador de percentagem (12,34%)
  static final NumberFormat _percentFormatter = NumberFormat.percentPattern(
    locale,
  );

  /// Formata valor como moeda
  /// Exemplo: 1234.56 -> "€ 1.234,56"
  static String formatCurrency(double value) {
    return _currencyFormatter.format(value);
  }

  /// Formata valor como moeda sem símbolo
  /// Exemplo: 1234.56 -> "1.234,56"
  static String formatCurrencyWithoutSymbol(double value) {
    return _numberFormatter.format(value);
  }

  /// Formata valor como moeda compacta
  /// Exemplo: 1234567 -> "€ 1,2M"
  static String formatCurrencyCompact(double value) {
    return _currencyCompactFormatter.format(value);
  }

  /// Formata valor com sinal (+ para positivo, - para negativo)
  /// Exemplo: 1234.56 -> "+€ 1.234,56" ou "-€ 1.234,56"
  static String formatCurrencyWithSign(double value) {
    final formatted = _currencyFormatter.format(value.abs());
    if (value > 0) {
      return '+$formatted';
    } else if (value < 0) {
      return '-$formatted';
    }
    return formatted;
  }

  /// Formata valor de receita (sempre positivo, cor verde)
  /// Exemplo: 1234.56 -> "+€ 1.234,56"
  static String formatIncome(double value) {
    return '+${_currencyFormatter.format(value.abs())}';
  }

  /// Formata valor de despesa (sempre negativo, cor vermelha)
  /// Exemplo: 1234.56 -> "-€ 1.234,56"
  static String formatExpense(double value) {
    return '-${_currencyFormatter.format(value.abs())}';
  }

  /// Formatador de data completa (21/11/2025)
  static final DateFormat _dateFormatter = DateFormat('dd/MM/yyyy', locale);

  /// Formatador de data abreviada (21/11)
  static final DateFormat _dateShortFormatter = DateFormat('dd/MM', locale);

  /// Formatador de data por extenso (21 de novembro de 2025)
  static final DateFormat _dateLongFormatter = DateFormat.yMMMMd(locale);

  /// Formatador de mês e ano (novembro 2025)
  static final DateFormat _monthYearFormatter = DateFormat.yMMMM(locale);

  /// Formatador de mês abreviado e ano (nov 2025)
  static final DateFormat _monthYearShortFormatter = DateFormat.yMMM(locale);

  /// Formatador de hora (14:30)
  static final DateFormat _timeFormatter = DateFormat.Hm(locale);

  /// Formatador de data e hora (21/11/2025 14:30)
  static final DateFormat _dateTimeFormatter = DateFormat(
    'dd/MM/yyyy HH:mm',
    locale,
  );

  /// Formatador de dia da semana (sexta-feira)
  static final DateFormat _weekdayFormatter = DateFormat.EEEE(locale);

  /// Formatador de dia da semana abreviado (sex)
  static final DateFormat _weekdayShortFormatter = DateFormat.E(locale);

  /// Formata data no padrão português (dd/MM/yyyy)
  /// Exemplo: DateTime(2025, 11, 21) -> "21/11/2025"
  static String formatDate(DateTime date) {
    return _dateFormatter.format(date);
  }

  /// Formata data abreviada (dd/MM)
  /// Exemplo: DateTime(2025, 11, 21) -> "21/11"
  static String formatDateShort(DateTime date) {
    return _dateShortFormatter.format(date);
  }

  /// Formata data por extenso
  /// Exemplo: DateTime(2025, 11, 21) -> "21 de novembro de 2025"
  static String formatDateLong(DateTime date) {
    return _dateLongFormatter.format(date);
  }

  /// Formata mês e ano
  /// Exemplo: DateTime(2025, 11, 21) -> "novembro de 2025"
  static String formatMonthYear(DateTime date) {
    return _monthYearFormatter.format(date);
  }

  /// Formata mês abreviado e ano
  /// Exemplo: DateTime(2025, 11, 21) -> "nov de 2025"
  static String formatMonthYearShort(DateTime date) {
    return _monthYearShortFormatter.format(date);
  }

  /// Formata hora
  /// Exemplo: DateTime(2025, 11, 21, 14, 30) -> "14:30"
  static String formatTime(DateTime date) {
    return _timeFormatter.format(date);
  }

  /// Formata data e hora
  /// Exemplo: DateTime(2025, 11, 21, 14, 30) -> "21/11/2025 14:30"
  static String formatDateTime(DateTime date) {
    return _dateTimeFormatter.format(date);
  }

  /// Formata dia da semana por extenso
  /// Exemplo: DateTime(2025, 11, 21) -> "sexta-feira"
  static String formatWeekday(DateTime date) {
    return _weekdayFormatter.format(date);
  }

  /// Formata dia da semana abreviado
  /// Exemplo: DateTime(2025, 11, 21) -> "sex"
  static String formatWeekdayShort(DateTime date) {
    return _weekdayShortFormatter.format(date);
  }

  /// Formata data relativa (Hoje, Ontem, ou data)
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    final difference = today.difference(dateOnly).inDays;

    if (difference == 0) {
      return 'Hoje';
    } else if (difference == 1) {
      return 'Ontem';
    } else if (difference == -1) {
      return 'Amanhã';
    } else if (difference > 0 && difference <= 7) {
      return 'Há $difference dias';
    } else {
      return formatDate(date);
    }
  }

  /// Formata período (01/11/2025 - 30/11/2025)
  static String formatDateRange(DateTime start, DateTime end) {
    return '${formatDate(start)} - ${formatDate(end)}';
  }

  /// Formata número com separador de milhar
  /// Exemplo: 1234567 -> "1.234.567"
  static String formatNumber(num value) {
    return _numberFormatter.format(value);
  }

  /// Formata percentagem
  /// Exemplo: 0.1234 -> "12,34%"
  static String formatPercent(double value) {
    return _percentFormatter.format(value);
  }

  /// Formata percentagem sem casas decimais
  /// Exemplo: 0.1234 -> "12%"
  static String formatPercentRounded(double value) {
    return '${(value * 100).round()}%';
  }

  /// Converte string formatada para double
  /// Exemplo: "1.234,56" -> 1234.56
  static double? parseCurrency(String value) {
    try {
      // Remove símbolo da moeda e espaços
      var cleanValue = value
          .replaceAll(currencySymbol, '')
          .replaceAll(' ', '')
          .trim();

      // Substitui separadores
      // Formato PT: 1.234,56 -> 1234.56
      cleanValue = cleanValue.replaceAll('.', '').replaceAll(',', '.');

      return double.tryParse(cleanValue);
    } catch (_) {
      return null;
    }
  }

  /// Converte string de data para DateTime
  /// Exemplo: "21/11/2025" -> DateTime(2025, 11, 21)
  static DateTime? parseDate(String value) {
    try {
      return _dateFormatter.parse(value);
    } catch (_) {
      return null;
    }
  }

  /// Formata nome de categoria (capitaliza primeira letra)
  static String formatCategoryName(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  /// Formata descrição (trim e capitaliza primeira letra)
  static String formatDescription(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return trimmed;
    return trimmed[0].toUpperCase() + trimmed.substring(1);
  }

  /// Mascara email para exibição
  /// Exemplo: "usuario@email.com" -> "u***o@email.com"
  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;

    final name = parts[0];
    final domain = parts[1];

    if (name.length <= 2) {
      return '${name[0]}***@$domain';
    }

    return '${name[0]}***${name[name.length - 1]}@$domain';
  }
}

/// Formatter para campos de moeda
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove tudo exceto números e vírgula
    String newText = newValue.text.replaceAll(RegExp(r'[^\d,]'), '');

    // Garante apenas uma vírgula
    final commaCount = ','.allMatches(newText).length;
    if (commaCount > 1) {
      newText = oldValue.text;
    }

    // Limita casas decimais a 2
    final parts = newText.split(',');
    if (parts.length == 2 && parts[1].length > 2) {
      newText = '${parts[0]},${parts[1].substring(0, 2)}';
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

/// Formatter para campos de data (dd/MM/yyyy)
class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.isEmpty) {
      return newValue;
    }

    // Remove tudo exceto números
    String digitsOnly = text.replaceAll(RegExp(r'[^\d]'), '');

    // Limita a 8 dígitos (ddMMyyyy)
    if (digitsOnly.length > 8) {
      digitsOnly = digitsOnly.substring(0, 8);
    }

    // Formata com barras
    final buffer = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 2 || i == 4) {
        buffer.write('/');
      }
      buffer.write(digitsOnly[i]);
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Formatter para aceitar apenas números
class DigitsOnlyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    return TextEditingValue(
      text: digitsOnly,
      selection: TextSelection.collapsed(offset: digitsOnly.length),
    );
  }
}

/// Formatter para aceitar apenas números e vírgula
class DecimalInputFormatter extends TextInputFormatter {
  final int decimalPlaces;

  DecimalInputFormatter({this.decimalPlaces = 2});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Permite apenas números e vírgula/ponto
    String newText = newValue.text.replaceAll(RegExp(r'[^\d.,]'), '');

    // Converte ponto para vírgula (padrão PT)
    newText = newText.replaceAll('.', ',');

    // Garante apenas uma vírgula
    final commaCount = ','.allMatches(newText).length;
    if (commaCount > 1) {
      return oldValue;
    }

    // Limita casas decimais
    final parts = newText.split(',');
    if (parts.length == 2 && parts[1].length > decimalPlaces) {
      newText = '${parts[0]},${parts[1].substring(0, decimalPlaces)}';
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
