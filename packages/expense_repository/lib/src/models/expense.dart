import 'package:expense_repository/expense_repository.dart';

class Expense {
  String expenseId;
  String remarks;
  String categoryId;
  DateTime date;
  double amount;

  Expense({
    required this.expenseId,
    required this.remarks,
    required this.categoryId,
    required this.date,
    required this.amount,
  });

  ExpenseEntity toEntity() {
    return ExpenseEntity(
      expenseId: expenseId,
      remarks: remarks,
      categoryId: categoryId,
      date: date,
      amount: amount
    );
  }

  static Expense fromEntity(ExpenseEntity entity) {
    return Expense(
      expenseId: entity.expenseId,
      remarks: entity.remarks,
      categoryId: entity.categoryId,
      date: entity.date,
      amount: entity.amount
    );
  }

  static final empty = Expense(
    expenseId: '',
    remarks: '',
    categoryId: '',
    date: DateTime.now(),
    amount: 0,
  );
}