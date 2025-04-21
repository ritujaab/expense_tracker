import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repository/expense_repository.dart';

class FirebaseExpenseRepo implements ExpenseRepository {

  final categoriesCollection = FirebaseFirestore.instance.collection('categories');
  final expensesCollection = FirebaseFirestore.instance.collection('expenses');

  @override
  Future<void> createCategory(Category category) async{
    try {
      await categoriesCollection
      .doc(category.categoryId)
      .set(category.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Category>> getCategory() async{
    try {
      return await categoriesCollection
          .get()
          .then((value) => value.docs.map((e) =>
          Category.fromEntity(CategoryEntity.fromDocument(e.data()))
      ).toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> createExpense(Expense expense) async{
    try {
      await expensesCollection
          .doc(expense.expenseId)
          .set(expense.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<Category> getCategoryById(String categoryId) async {
    try {
      final doc = await categoriesCollection.doc(categoryId).get();
      if (!doc.exists) throw Exception("Category not found");
      return Category.fromEntity(CategoryEntity.fromDocument(doc.data()!));
    } catch (e) {
      log("getCategoryById error: ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<void> updateCategory(Category category) async {
    try {
      await categoriesCollection
          .doc(category.categoryId)
          .update(category.toEntity().toDocument());
    } catch (e) {
      log("updateCategory error: ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<List<Expense>> getExpenses() async{
    try {
      return await expensesCollection
          .get()
          .then((value) => value.docs.map((e) =>
          Expense.fromEntity(ExpenseEntity.fromDocument(e.data()))
      ).toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<String> deleteExpense(String expenseId) async {
    try {
      await expensesCollection.doc(expenseId).delete();
      return expenseId;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

}