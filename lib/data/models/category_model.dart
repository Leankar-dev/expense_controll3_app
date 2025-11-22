import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final String color;
  final double? budgetLimit;
  final String userId;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final DateTime? syncedAt;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.budgetLimit,
    required this.userId,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
    this.syncedAt,
  });

  Color get colorValue => AppColors.fromHex(color);

  Color get backgroundColorValue => colorValue.withValues(alpha: 0.15);

  bool get hasBudgetLimit => budgetLimit != null && budgetLimit! > 0;

  bool get isSynced => syncedAt != null;

  bool get needsSync => syncedAt == null || updatedAt.isAfter(syncedAt!);

  CategoryModel copyWith({
    String? id,
    String? name,
    String? icon,
    String? color,
    double? budgetLimit,
    String? userId,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? syncedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      budgetLimit: budgetLimit ?? this.budgetLimit,
      userId: userId ?? this.userId,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
      'budgetLimit': budgetLimit,
      'userId': userId,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isDeleted': isDeleted,
      'syncedAt': syncedAt?.toIso8601String(),
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      budgetLimit: json['budgetLimit'] != null
          ? (json['budgetLimit'] as num).toDouble()
          : null,
      userId: json['userId'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
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
      'name': name,
      'icon': icon,
      'color': color,
      'budgetLimit': budgetLimit,
      'userId': userId,
      'isDefault': isDefault,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isDeleted': isDeleted,
    };
  }

  factory CategoryModel.fromFirestore(Map<String, dynamic> doc) {
    return CategoryModel(
      id: doc['id'] as String,
      name: doc['name'] as String,
      icon: doc['icon'] as String,
      color: doc['color'] as String,
      budgetLimit: doc['budgetLimit'] != null
          ? (doc['budgetLimit'] as num).toDouble()
          : null,
      userId: doc['userId'] as String,
      isDefault: doc['isDefault'] as bool? ?? false,
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
      updatedAt: (doc['updatedAt'] as Timestamp).toDate(),
      isDeleted: doc['isDeleted'] as bool? ?? false,
      syncedAt: DateTime.now(),
    );
  }

  factory CategoryModel.create({
    required String id,
    required String name,
    required String icon,
    required String color,
    double? budgetLimit,
    required String userId,
    bool isDefault = false,
  }) {
    final now = DateTime.now();
    return CategoryModel(
      id: id,
      name: name,
      icon: icon,
      color: color,
      budgetLimit: budgetLimit,
      userId: userId,
      isDefault: isDefault,
      createdAt: now,
      updatedAt: now,
      isDeleted: false,
      syncedAt: null,
    );
  }

  CategoryModel markAsDeleted() {
    return copyWith(
      isDeleted: true,
      updatedAt: DateTime.now(),
    );
  }

  CategoryModel markAsSynced() {
    return copyWith(syncedAt: DateTime.now());
  }

  CategoryModel update({
    String? name,
    String? icon,
    String? color,
    double? budgetLimit,
  }) {
    return copyWith(
      name: name,
      icon: icon,
      color: color,
      budgetLimit: budgetLimit,
      updatedAt: DateTime.now(),
    );
  }

  CategoryModel removeBudgetLimit() {
    return CategoryModel(
      id: id,
      name: name,
      icon: icon,
      color: color,
      budgetLimit: null,
      userId: userId,
      isDefault: isDefault,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      isDeleted: isDeleted,
      syncedAt: syncedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, icon: $icon, color: $color)';
  }
}

abstract final class DefaultCategories {
  static List<CategoryModel> getDefaultCategories(String userId) {
    final now = DateTime.now();

    return [
      CategoryModel(
        id: 'default_food',
        name: 'Alimentação',
        icon: '🍔',
        color: '#FF5733',
        budgetLimit: null,
        userId: userId,
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      ),
      CategoryModel(
        id: 'default_transport',
        name: 'Transporte',
        icon: '🚗',
        color: '#3498DB',
        budgetLimit: null,
        userId: userId,
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      ),
      CategoryModel(
        id: 'default_health',
        name: 'Saúde',
        icon: '💊',
        color: '#2ECC71',
        budgetLimit: null,
        userId: userId,
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      ),
      CategoryModel(
        id: 'default_leisure',
        name: 'Lazer',
        icon: '🎮',
        color: '#9B59B6',
        budgetLimit: null,
        userId: userId,
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      ),
      CategoryModel(
        id: 'default_others',
        name: 'Outros',
        icon: '📦',
        color: '#95A5A6',
        budgetLimit: null,
        userId: userId,
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
