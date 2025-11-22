import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

enum TransactionType {
  income,

  expense
  ;

  String get displayName {
    return switch (this) {
      TransactionType.income => 'Receita',
      TransactionType.expense => 'Despesa',
    };
  }

  String get displayNamePlural {
    return switch (this) {
      TransactionType.income => 'Receitas',
      TransactionType.expense => 'Despesas',
    };
  }

  Color get color {
    return switch (this) {
      TransactionType.income => AppColors.income,
      TransactionType.expense => AppColors.expense,
    };
  }

  Color get backgroundColor {
    return switch (this) {
      TransactionType.income => AppColors.incomeLight,
      TransactionType.expense => AppColors.expenseLight,
    };
  }

  Color get darkColor {
    return switch (this) {
      TransactionType.income => AppColors.incomeDark,
      TransactionType.expense => AppColors.expenseDark,
    };
  }

  IconData get icon {
    return switch (this) {
      TransactionType.income => Icons.arrow_upward,
      TransactionType.expense => Icons.arrow_downward,
    };
  }

  IconData get iconOutlined {
    return switch (this) {
      TransactionType.income => Icons.trending_up,
      TransactionType.expense => Icons.trending_down,
    };
  }

  String get valuePrefix {
    return switch (this) {
      TransactionType.income => '+',
      TransactionType.expense => '-',
    };
  }

  bool get isIncome => this == TransactionType.income;

  bool get isExpense => this == TransactionType.expense;

  int get multiplier {
    return switch (this) {
      TransactionType.income => 1,
      TransactionType.expense => -1,
    };
  }

  static TransactionType fromString(String value) {
    return TransactionType.values.firstWhere(
      (type) => type.name.toLowerCase() == value.toLowerCase(),
      orElse: () => TransactionType.expense,
    );
  }

  static TransactionType fromIndex(int index) {
    if (index < 0 || index >= TransactionType.values.length) {
      return TransactionType.expense;
    }
    return TransactionType.values[index];
  }

  TransactionType get opposite {
    return switch (this) {
      TransactionType.income => TransactionType.expense,
      TransactionType.expense => TransactionType.income,
    };
  }
}

extension TransactionTypeListExtension on List<TransactionType> {
  List<String> get displayNames => map((t) => t.displayName).toList();
}
