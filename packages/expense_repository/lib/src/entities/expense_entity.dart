import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/models.dart';

class ExpenseEntity {
  String expenseId;
  String categoryId;
  DateTime date;
  double amount;
  String type;

  ExpenseEntity({
    required this.expenseId,
    required this.categoryId,
    required this.date,
    required this.amount,
    required this.type
  });

  Map<String, Object?> toDocument() {
    return {
      'expenseId': expenseId,
      'category': categoryId,
      'date': date,
      'amount': amount,
      'type': type
    };
  }

  static ExpenseEntity fromDocument(Map<String, dynamic> doc) {
    return ExpenseEntity(
      expenseId: doc['expenseId'],
      categoryId: doc['category'],
      date: (doc['date'] as Timestamp).toDate(),
      amount: doc['amount'],
      type: doc['type']
    );
  }
}