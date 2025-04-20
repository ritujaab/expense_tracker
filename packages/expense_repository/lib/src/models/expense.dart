import 'package:expense_repository/expense_repository.dart';

class Expense {
  String expenseId;
  String categoryId;
  DateTime date;
  double amount;
  String type;

  Expense({
    required this.expenseId,
    required this.categoryId,
    required this.date,
    required this.amount,
    required this.type
  });

  ExpenseEntity toEntity() {
    return ExpenseEntity(
      expenseId: expenseId,
      categoryId: categoryId,
      date: date,
      amount: amount,
      type: type
    );
  }

  static Expense fromEntity(ExpenseEntity entity) {
    return Expense(
      expenseId: entity.expenseId,
      categoryId: entity.categoryId,
      date: entity.date,
      amount: entity.amount,
      type: entity.type
    );
  }

  static final empty = Expense(
    expenseId: '',
    categoryId: '',
    date: DateTime.now(),
    amount: 0,
    type: ''
  );
}