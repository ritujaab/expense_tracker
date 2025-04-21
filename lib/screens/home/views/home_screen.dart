import 'dart:math';

import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker/screens/add_expense/blocs/create_expense/create_expense_bloc.dart';
import 'package:expense_tracker/screens/add_expense/blocs/get_categories/get_categories_bloc.dart';
import 'package:expense_tracker/screens/add_expense/views/add_expense.dart';
import 'package:expense_tracker/screens/home/blocs/get_expenses/get_expenses_bloc.dart';
import 'package:expense_tracker/screens/home/views/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../add_expense/blocs/create_category/create_category_bloc.dart';
import '../../stats/stats.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int index = 0;
  late Color selectedItem = Colors.lightBlueAccent;
  late Color unselectedItem = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetExpensesBloc, GetExpensesState>(
      builder: (context, expensesState) {
        if(expensesState is GetExpensesSuccess) {
          return BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
            builder: (context, categoriesState) {
              if (categoriesState is GetCategoriesSuccess) {
                return Scaffold(
                  bottomNavigationBar: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24.0),
                    ),
                    child: BottomNavigationBar(
                      onTap: (value) {
                        setState(() {
                          index = value;
                        });
                      },
                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      elevation: 3,
                      items: [
                        BottomNavigationBarItem(
                          icon: Icon(
                            CupertinoIcons.home,
                            color: index == 0 ? selectedItem : unselectedItem,
                          ),
                          label: 'Home',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(
                            CupertinoIcons.graph_square_fill,
                            color: index == 1 ? selectedItem : unselectedItem,
                          ),
                          label: 'Stats',
                        ),
                      ],
                    ),
                  ),
                  floatingActionButtonLocation: FloatingActionButtonLocation
                      .centerDocked,
                  floatingActionButton: FloatingActionButton(
                    onPressed: () async {
                      var list = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MultiBlocProvider(
                                    providers: [
                                      BlocProvider(
                                        create: (context) =>
                                            CreateCategoryBloc(
                                                FirebaseExpenseRepo()),
                                      ),
                                      BlocProvider(
                                        create: (context) =>
                                        GetCategoriesBloc(FirebaseExpenseRepo())
                                          ..add(
                                              GetCategories()
                                          ),
                                      ),
                                      BlocProvider(
                                        create: (context) =>
                                            CreateExpenseBloc(
                                                FirebaseExpenseRepo()),
                                      ),
                                    ],
                                    child: const AddExpense(),
                                  )
                          )
                      );
                      debugPrint("Returned values from AddExpense: $list");
                      if(list[0]) {
                        setState(() {
                          context.read<GetExpensesBloc>().add(GetExpenses());
                        });
                      }
                      if(list[1]) {
                        setState(() {
                          context.read<GetCategoriesBloc>().add(GetCategories());
                        });
                      }
                    },
                    shape: const CircleBorder(),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Theme
                                  .of(context)
                                  .colorScheme
                                  .primary,
                              Theme
                                  .of(context)
                                  .colorScheme
                                  .secondary,
                              Theme
                                  .of(context)
                                  .colorScheme
                                  .tertiary,
                            ],
                            transform: const GradientRotation(pi / 4),
                          )
                      ),
                      child: const Icon(
                        CupertinoIcons.add,
                      ),
                    ),
                  ),
                  body: index == 0
                      ? MainScreen(expensesState.expenses, categoriesState.categories)
                      : StatsScreen(categoriesState.categories),
                );
              } else {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      }
    );
  }
}
