import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'update_expense_event.dart';
part 'update_expense_state.dart';

class UpdateExpenseBloc extends Bloc<UpdateExpenseEvent, UpdateExpenseState> {
  UpdateExpenseBloc() : super(UpdateExpenseInitial()) {
    on<UpdateExpenseEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
