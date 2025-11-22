import 'package:expense_controll3_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum PaymentMethod {
  creditCard,
  debitCard,
  mbWay,
  pix,
  cash
  ;

  String get displayName {
    return switch (this) {
      PaymentMethod.creditCard => 'Cartão de Crédito',
      PaymentMethod.debitCard => 'Cartão de Débito',
      PaymentMethod.mbWay => 'MBWay',
      PaymentMethod.pix => 'PIX',
      PaymentMethod.cash => 'Dinheiro',
    };
  }

  String get shortName {
    return switch (this) {
      PaymentMethod.creditCard => 'Crédito',
      PaymentMethod.debitCard => 'Débito',
      PaymentMethod.mbWay => 'MBWay',
      PaymentMethod.pix => 'PIX',
      PaymentMethod.cash => 'Dinheiro',
    };
  }

  IconData get icon {
    return switch (this) {
      PaymentMethod.creditCard => Icons.credit_card,
      PaymentMethod.debitCard => Icons.credit_card_outlined,
      PaymentMethod.mbWay => Icons.phone_android,
      PaymentMethod.pix => Icons.pix,
      PaymentMethod.cash => Icons.money,
    };
  }

  Color get color {
    return switch (this) {
      PaymentMethod.creditCard => AppColors.paymentCreditCard,
      PaymentMethod.debitCard => AppColors.paymentDebitCard,
      PaymentMethod.mbWay => AppColors.paymentMbWay,
      PaymentMethod.pix => AppColors.paymentPix,
      PaymentMethod.cash => AppColors.paymentCash,
    };
  }

  Color get backgroundColor {
    return color.withValues(alpha: 0.1);
  }

  String get description {
    return switch (this) {
      PaymentMethod.creditCard => 'Pagamento com cartão de crédito',
      PaymentMethod.debitCard => 'Pagamento com cartão de débito',
      PaymentMethod.mbWay => 'Pagamento via aplicação MBWay',
      PaymentMethod.pix => 'Transferência instantânea PIX',
      PaymentMethod.cash => 'Pagamento em dinheiro',
    };
  }

  bool get isDigital {
    return switch (this) {
      PaymentMethod.creditCard => true,
      PaymentMethod.debitCard => true,
      PaymentMethod.mbWay => true,
      PaymentMethod.pix => true,
      PaymentMethod.cash => false,
    };
  }

  bool get isCard {
    return this == PaymentMethod.creditCard || this == PaymentMethod.debitCard;
  }

  bool get isMobile {
    return this == PaymentMethod.mbWay || this == PaymentMethod.pix;
  }

  bool get isCash => this == PaymentMethod.cash;

  static PaymentMethod fromString(String value) {
    return PaymentMethod.values.firstWhere(
      (method) => method.name.toLowerCase() == value.toLowerCase(),
      orElse: () => PaymentMethod.cash,
    );
  }

  static PaymentMethod fromIndex(int index) {
    if (index < 0 || index >= PaymentMethod.values.length) {
      return PaymentMethod.cash;
    }
    return PaymentMethod.values[index];
  }

  static List<({PaymentMethod method, String label, IconData icon})>
  get dropdownOptions {
    return PaymentMethod.values
        .map(
          (method) => (
            method: method,
            label: method.displayName,
            icon: method.icon,
          ),
        )
        .toList();
  }

  static Map<String, List<PaymentMethod>> get grouped {
    return {
      'Cartões': [PaymentMethod.creditCard, PaymentMethod.debitCard],
      'Pagamento Móvel': [PaymentMethod.mbWay, PaymentMethod.pix],
      'Outros': [PaymentMethod.cash],
    };
  }
}

extension PaymentMethodListExtension on List<PaymentMethod> {
  List<String> get displayNames => map((m) => m.displayName).toList();

  List<PaymentMethod> get digitalOnly => where((m) => m.isDigital).toList();

  List<PaymentMethod> get cardsOnly => where((m) => m.isCard).toList();

  List<PaymentMethod> get mobileOnly => where((m) => m.isMobile).toList();
}
