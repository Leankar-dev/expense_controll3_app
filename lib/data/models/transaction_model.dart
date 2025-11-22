import 'package:cloud_firestore/cloud_firestore.dart';

import '../enums/payment_method.dart';
import '../enums/transaction_type.dart';

class TransactionModel {
  final String id;
  final double amount;
  final String category;
  final String description;
  final DateTime date;
  final PaymentMethod paymentMethod;
  final TransactionType type;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final DateTime? syncedAt;

  const TransactionModel({
    required this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    required this.paymentMethod,
    required this.type,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
    this.syncedAt,
  });

  bool get isIncome => type == TransactionType.income;

  bool get isExpense => type == TransactionType.expense;

  double get signedAmount => amount * type.multiplier;

  bool get isSynced => syncedAt != null;

  bool get needsSync => syncedAt == null || updatedAt.isAfter(syncedAt!);

  TransactionModel copyWith({
    String? id,
    double? amount,
    String? category,
    String? description,
    DateTime? date,
    PaymentMethod? paymentMethod,
    TransactionType? type,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? syncedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'description': description,
      'date': date.toIso8601String(),
      'paymentMethod': paymentMethod.name,
      'type': type.name,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isDeleted': isDeleted,
      'syncedAt': syncedAt?.toIso8601String(),
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      paymentMethod: PaymentMethod.fromString(json['paymentMethod'] as String),
      type: TransactionType.fromString(json['type'] as String),
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isDeleted: json['isDeleted'] as bool? ?? false,
      syncedAt: json['syncedAt'] != null
          ? DateTime.parse(json['syncedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'description': description,
      'date': Timestamp.fromDate(date),
      'paymentMethod': paymentMethod.name,
      'type': type.name,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isDeleted': isDeleted,
    };
  }

  factory TransactionModel.fromFirestore(Map<String, dynamic> doc) {
    return TransactionModel(
      id: doc['id'] as String,
      amount: (doc['amount'] as num).toDouble(),
      category: doc['category'] as String,
      description: doc['description'] as String,
      date: (doc['date'] as Timestamp).toDate(),
      paymentMethod: PaymentMethod.fromString(doc['paymentMethod'] as String),
      type: TransactionType.fromString(doc['type'] as String),
      userId: doc['userId'] as String,
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
      updatedAt: (doc['updatedAt'] as Timestamp).toDate(),
      isDeleted: doc['isDeleted'] as bool? ?? false,
      syncedAt: DateTime.now(),
    );
  }

  factory TransactionModel.create({
    required String id,
    required double amount,
    required String category,
    required String description,
    required DateTime date,
    required PaymentMethod paymentMethod,
    required TransactionType type,
    required String userId,
  }) {
    final now = DateTime.now();
    return TransactionModel(
      id: id,
      amount: amount,
      category: category,
      description: description,
      date: date,
      paymentMethod: paymentMethod,
      type: type,
      userId: userId,
      createdAt: now,
      updatedAt: now,
      isDeleted: false,
      syncedAt: null,
    );
  }

  TransactionModel markAsDeleted() {
    return copyWith(
      isDeleted: true,
      updatedAt: DateTime.now(),
    );
  }

  TransactionModel markAsSynced() {
    return copyWith(syncedAt: DateTime.now());
  }

  TransactionModel update({
    double? amount,
    String? category,
    String? description,
    DateTime? date,
    PaymentMethod? paymentMethod,
    TransactionType? type,
  }) {
    return copyWith(
      amount: amount,
      category: category,
      description: description,
      date: date,
      paymentMethod: paymentMethod,
      type: type,
      updatedAt: DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TransactionModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'TransactionModel(id: $id, amount: $amount, category: $category, '
        'type: ${type.name}, date: $date)';
  }
}
