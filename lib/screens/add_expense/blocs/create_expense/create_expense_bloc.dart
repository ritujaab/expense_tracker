import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';

part 'create_expense_event.dart';
part 'create_expense_state.dart';

class CreateExpenseBloc extends Bloc<CreateExpenseEvent, CreateExpenseState> {
  ExpenseRepository expenseRepository;
  CreateExpenseBloc(this.expenseRepository) : super(CreateExpenseInitial()) {
    on<CreateExpense>((event, emit) async {
      emit(CreateExpenseLoading());
      try {

        final category = await expenseRepository.getCategoryById(event.expense.categoryId);
        category.totalExpenses += event.expense.amount;
        await expenseRepository.updateCategory(category);
        await expenseRepository.createExpense(event.expense);

        emit(CreateExpenseSuccess());
      } catch(e) {
        emit(CreateExpenseFailure());
      }
    });
  }
}
