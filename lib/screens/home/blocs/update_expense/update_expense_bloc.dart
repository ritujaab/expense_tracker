import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';

part 'update_expense_event.dart';
part 'update_expense_state.dart';

class UpdateExpenseBloc extends Bloc<UpdateExpenseEvent, UpdateExpenseState> {
  final ExpenseRepository expenseRepository;

  UpdateExpenseBloc(this.expenseRepository) : super(UpdateExpenseInitial()) {
    on<UpdateExpense>((event, emit) async {
      emit(UpdateExpenseLoading());
      try {
        final oldExpense = await expenseRepository.getExpenseById(event.expense.expenseId);

        if (oldExpense.categoryId != event.expense.categoryId) {
          final oldCategory = await expenseRepository.getCategoryById(oldExpense.categoryId);
          final newCategory = await expenseRepository.getCategoryById(event.expense.categoryId);

          oldCategory.totalExpenses -= oldExpense.amount;
          newCategory.totalExpenses += event.expense.amount;

          await expenseRepository.updateCategory(oldCategory);
          await expenseRepository.updateCategory(newCategory);
        } else {
          final category = await expenseRepository.getCategoryById(event.expense.categoryId);
          category.totalExpenses += event.expense.amount - oldExpense.amount;
          await expenseRepository.updateCategory(category);
        }

        await expenseRepository.updateExpense(event.expense);

        emit(UpdateExpenseSuccess());
      } catch (e) {
        emit(UpdateExpenseFailure());
      }
    });
  }
}
