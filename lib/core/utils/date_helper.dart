/// Classe utilitária para manipulação de datas.
/// Fornece métodos para cálculos e operações com datas.
abstract final class DateHelper {
  /// Retorna a data atual (sem hora)
  static DateTime get today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Retorna a data e hora atual
  static DateTime get now => DateTime.now();

  /// Retorna ontem (sem hora)
  static DateTime get yesterday => today.subtract(const Duration(days: 1));

  /// Retorna amanhã (sem hora)
  static DateTime get tomorrow => today.add(const Duration(days: 1));

  /// Retorna o início do dia (00:00:00)
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Retorna o fim do dia (23:59:59.999)
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Retorna o primeiro dia da semana (segunda-feira)
  static DateTime startOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return startOfDay(date.subtract(Duration(days: daysFromMonday)));
  }

  /// Retorna o último dia da semana (domingo)
  static DateTime endOfWeek(DateTime date) {
    final daysUntilSunday = 7 - date.weekday;
    return endOfDay(date.add(Duration(days: daysUntilSunday)));
  }

  /// Retorna o primeiro dia do mês
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Retorna o último dia do mês
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
  }

  /// Retorna o primeiro dia do ano
  static DateTime startOfYear(DateTime date) {
    return DateTime(date.year, 1, 1);
  }

  /// Retorna o último dia do ano
  static DateTime endOfYear(DateTime date) {
    return DateTime(date.year, 12, 31, 23, 59, 59, 999);
  }

  /// Retorna o intervalo da semana atual
  static ({DateTime start, DateTime end}) get currentWeek {
    return (start: startOfWeek(today), end: endOfWeek(today));
  }

  /// Retorna o intervalo do mês atual
  static ({DateTime start, DateTime end}) get currentMonth {
    return (start: startOfMonth(today), end: endOfMonth(today));
  }

  /// Retorna o intervalo do ano atual
  static ({DateTime start, DateTime end}) get currentYear {
    return (start: startOfYear(today), end: endOfYear(today));
  }

  /// Retorna o intervalo da semana passada
  static ({DateTime start, DateTime end}) get lastWeek {
    final lastWeekDate = today.subtract(const Duration(days: 7));
    return (start: startOfWeek(lastWeekDate), end: endOfWeek(lastWeekDate));
  }

  /// Retorna o intervalo do mês passado
  static ({DateTime start, DateTime end}) get lastMonth {
    final lastMonthDate = DateTime(today.year, today.month - 1, 1);
    return (start: startOfMonth(lastMonthDate), end: endOfMonth(lastMonthDate));
  }

  /// Retorna o intervalo dos últimos 7 dias
  static ({DateTime start, DateTime end}) get last7Days {
    return (
      start: startOfDay(today.subtract(const Duration(days: 6))),
      end: endOfDay(today),
    );
  }

  /// Retorna o intervalo dos últimos 30 dias
  static ({DateTime start, DateTime end}) get last30Days {
    return (
      start: startOfDay(today.subtract(const Duration(days: 29))),
      end: endOfDay(today),
    );
  }

  /// Retorna o intervalo dos últimos 90 dias
  static ({DateTime start, DateTime end}) get last90Days {
    return (
      start: startOfDay(today.subtract(const Duration(days: 89))),
      end: endOfDay(today),
    );
  }

  /// Retorna o intervalo dos últimos 12 meses
  static ({DateTime start, DateTime end}) get last12Months {
    final start = DateTime(today.year - 1, today.month, today.day);
    return (start: startOfDay(start), end: endOfDay(today));
  }

  /// Verifica se duas datas são o mesmo dia
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Verifica se duas datas são o mesmo mês
  static bool isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }

  /// Verifica se duas datas são o mesmo ano
  static bool isSameYear(DateTime date1, DateTime date2) {
    return date1.year == date2.year;
  }

  /// Verifica se a data é hoje
  static bool isToday(DateTime date) {
    return isSameDay(date, today);
  }

  /// Verifica se a data é ontem
  static bool isYesterday(DateTime date) {
    return isSameDay(date, yesterday);
  }

  /// Verifica se a data é amanhã
  static bool isTomorrow(DateTime date) {
    return isSameDay(date, tomorrow);
  }

  /// Verifica se a data está na semana atual
  static bool isThisWeek(DateTime date) {
    final week = currentWeek;
    return !date.isBefore(week.start) && !date.isAfter(week.end);
  }

  /// Verifica se a data está no mês atual
  static bool isThisMonth(DateTime date) {
    return isSameMonth(date, today);
  }

  /// Verifica se a data está no ano atual
  static bool isThisYear(DateTime date) {
    return isSameYear(date, today);
  }

  /// Verifica se a data é no passado
  static bool isPast(DateTime date) {
    return date.isBefore(today);
  }

  /// Verifica se a data é no futuro
  static bool isFuture(DateTime date) {
    return date.isAfter(today);
  }

  /// Verifica se a data está dentro de um intervalo
  static bool isInRange(DateTime date, DateTime start, DateTime end) {
    return !date.isBefore(start) && !date.isAfter(end);
  }

  /// Retorna o número de dias entre duas datas
  static int daysBetween(DateTime start, DateTime end) {
    final startDate = startOfDay(start);
    final endDate = startOfDay(end);
    return endDate.difference(startDate).inDays;
  }

  /// Retorna o número de meses entre duas datas
  static int monthsBetween(DateTime start, DateTime end) {
    return (end.year - start.year) * 12 + (end.month - start.month);
  }

  /// Retorna o número de anos entre duas datas
  static int yearsBetween(DateTime start, DateTime end) {
    return end.year - start.year;
  }

  /// Retorna o número de dias no mês
  static int daysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  /// Retorna o número do trimestre (1-4)
  static int quarter(DateTime date) {
    return ((date.month - 1) / 3).floor() + 1;
  }

  /// Adiciona dias úteis (exclui fins de semana)
  static DateTime addBusinessDays(DateTime date, int days) {
    var result = date;
    var addedDays = 0;

    while (addedDays < days) {
      result = result.add(const Duration(days: 1));
      if (result.weekday != DateTime.saturday &&
          result.weekday != DateTime.sunday) {
        addedDays++;
      }
    }

    return result;
  }

  /// Retorna lista de todos os dias entre duas datas
  static List<DateTime> daysBetweenAsList(DateTime start, DateTime end) {
    final days = <DateTime>[];
    var current = startOfDay(start);
    final endDate = startOfDay(end);

    while (!current.isAfter(endDate)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }

    return days;
  }

  /// Retorna lista de todos os meses entre duas datas
  static List<DateTime> monthsBetweenAsList(DateTime start, DateTime end) {
    final months = <DateTime>[];
    var current = DateTime(start.year, start.month, 1);
    final endMonth = DateTime(end.year, end.month, 1);

    while (!current.isAfter(endMonth)) {
      months.add(current);
      current = DateTime(current.year, current.month + 1, 1);
    }

    return months;
  }

  /// Retorna lista dos últimos N meses
  static List<DateTime> lastNMonths(int n) {
    final months = <DateTime>[];
    var current = DateTime(today.year, today.month, 1);

    for (var i = 0; i < n; i++) {
      months.add(current);
      current = DateTime(current.year, current.month - 1, 1);
    }

    return months.reversed.toList();
  }

  /// Retorna lista dos dias da semana atual
  static List<DateTime> currentWeekDays() {
    final week = currentWeek;
    return daysBetweenAsList(week.start, week.end);
  }

  /// Retorna lista dos dias do mês atual
  static List<DateTime> currentMonthDays() {
    final month = currentMonth;
    return daysBetweenAsList(month.start, month.end);
  }

  /// Retorna descrição relativa da data
  /// Exemplos: "Hoje", "Ontem", "Há 3 dias", "Há 1 semana"
  static String relativeDescription(DateTime date) {
    final difference = today.difference(startOfDay(date)).inDays;

    if (difference == 0) {
      return 'Hoje';
    } else if (difference == 1) {
      return 'Ontem';
    } else if (difference == -1) {
      return 'Amanhã';
    } else if (difference > 1 && difference <= 7) {
      return 'Há $difference dias';
    } else if (difference > 7 && difference <= 14) {
      return 'Há 1 semana';
    } else if (difference > 14 && difference <= 21) {
      return 'Há 2 semanas';
    } else if (difference > 21 && difference <= 30) {
      return 'Há 3 semanas';
    } else if (difference > 30 && difference <= 60) {
      return 'Há 1 mês';
    } else if (difference > 60 && difference <= 90) {
      return 'Há 2 meses';
    } else if (difference > 90 && difference <= 365) {
      final months = (difference / 30).round();
      return 'Há $months meses';
    } else if (difference > 365) {
      final years = (difference / 365).round();
      return years == 1 ? 'Há 1 ano' : 'Há $years anos';
    } else if (difference < -1 && difference >= -7) {
      return 'Em ${difference.abs()} dias';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Retorna nome do mês em português
  static String monthName(int month) {
    const months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];
    return months[month - 1];
  }

  /// Retorna nome abreviado do mês em português
  static String monthNameShort(int month) {
    const months = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez',
    ];
    return months[month - 1];
  }

  /// Retorna nome do dia da semana em português
  static String weekdayName(int weekday) {
    const weekdays = [
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado',
      'Domingo',
    ];
    return weekdays[weekday - 1];
  }

  /// Retorna nome abreviado do dia da semana em português
  static String weekdayNameShort(int weekday) {
    const weekdays = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    return weekdays[weekday - 1];
  }
}
