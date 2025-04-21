import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseEntity {
  String expenseId;
  String remarks;
  String categoryId;
  DateTime date;
  double amount;

  ExpenseEntity({
    required this.expenseId,
    required this.remarks,
    required this.categoryId,
    required this.date,
    required this.amount,
  });

  Map<String, Object?> toDocument() {
    return {
      'expenseId': expenseId,
      'remarks': remarks,
      'category': categoryId,
      'date': date,
      'amount': amount,
    };
  }

  static ExpenseEntity fromDocument(Map<String, dynamic> doc) {
    return ExpenseEntity(
      expenseId: doc['expenseId'],
      remarks: doc['remarks'],
      categoryId: doc['category'],
      date: (doc['date'] as Timestamp).toDate(),
      amount: doc['amount']
    );
  }
}