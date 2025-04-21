import 'package:flutter/material.dart';

import '../entities/entities.dart';

class Category {
  String categoryId;
  String name;
  double totalExpenses;
  String icon;
  String color;
  String type;

  Category({
    required this.categoryId,
    required this.name,
    required this.totalExpenses,
    required this.icon,
    required this.color,
    required this.type
  });

  static final empty = Category(
      categoryId: '',
      name: '',
      totalExpenses: 0,
      icon: '',
      color: Colors.white.toString(),
      type: ''
  );

  CategoryEntity toEntity() {
    return CategoryEntity(
      categoryId: categoryId,
      name: name,
      totalExpenses: totalExpenses,
      icon: icon,
      color: color,
      type: type
    );
  }

  static Category fromEntity(CategoryEntity entity) {
    return Category(
      categoryId: entity.categoryId,
      name: entity.name,
      totalExpenses: entity.totalExpenses,
      icon: entity.icon,
      color: entity.color,
      type: entity.type
    );
  }
}
