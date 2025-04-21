import 'package:expense_repository/expense_repository.dart';

abstract class ExpenseRepository {

  Future<void> createCategory(Category category);
  Future<List<Category>> getCategory();

  Future<void> createExpense(Expense expense);
  Future<Category> getCategoryById(String categoryId);
  Future<Expense> getExpenseById(String expenseId);
  Future<void> updateCategory(Category category);
  Future<List<Expense>> getExpenses();
  Future<String> deleteExpense(String expenseId);
  Future<void> updateExpense(Expense expense);
}