import 'dart:math';
import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker/screens/home/views/edit_transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../data/data.dart';
import '../blocs/delete_expense/delete_expense_bloc.dart';
import '../blocs/update_expense/update_expense_bloc.dart';
import 'delete_expense.dart';

class MainScreen extends StatefulWidget {
  final List<Expense> expenses;
  final List<Category> categories;
  const MainScreen(this.expenses, this.categories, {super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final Map<String, Category> categoryMap;
  String deletedExpenseId = '';

  @override
  void initState() {
    super.initState();
    categoryMap = {
      for (var category in widget.categories) category.categoryId: category
    };
  }

  double getTotalExpenses() {
    double total = 0;
    for(var expense in widget.expenses) {
      if(categoryMap[expense.categoryId]?.type == 'Expense') {
        total += expense.amount;
      }
    }
    return total;
  }

  double getTotalIncome() {
    double total = 0;
    for(var expense in widget.expenses) {
      if(categoryMap[expense.categoryId]?.type == 'Income') {
        total += expense.amount;
      }
    }
    return total;
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    widget.expenses.removeWhere((e) => e.expenseId == deletedExpenseId);
    List<Expense> sortedExpenses = [...widget.expenses];
    sortedExpenses.sort((a, b) => b.date.compareTo(a.date));

    return SafeArea(
      child: BlocListener<DeleteExpenseBloc, DeleteExpenseState>(
        listener: (context, state) {
          if(state is DeleteExpenseSuccess) {
            setState(() {
              isLoading = false;
              deletedExpenseId = state.expenseId;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Expense deleted successfully")),
            );
          } else if(state is DeleteExpenseFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Something went wrong")),
            );
          } else if(state is DeleteExpenseLoading) {
            setState(() {
              isLoading = true;
            });
          }
        },
        child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFE0A5F6)
                              ),
                            ),
                            const Icon(
                              CupertinoIcons.person_alt,
                              color: Color(0xFF770597),
                            )
                          ],
                        ),
                        const SizedBox(width: 8,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome!",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.outline
                              ),
                            ),
                            Text(
                              "Ritujaa",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onBackground
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 30,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.tertiary,
                      ],
                      transform: const GradientRotation(pi / 4),
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 4,
                          color: Colors.grey.shade400,
                          offset: const Offset(5, 5)
                      )
                    ]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Total Balance",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                        ),
                      ),
                      const SizedBox(height: 12,),
                      Text(
                        "₹${getTotalIncome() - getTotalExpenses()}",
                        style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                      const SizedBox(height: 12,),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 25,
                                  height: 25,
                                  decoration: const BoxDecoration(
                                    color: Colors.white30,
                                    shape: BoxShape.circle
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      CupertinoIcons.arrow_up,
                                      color: Colors.green,
                                      size: 12,
                                    )
                                  ),
                                ),
                                const SizedBox(width: 8,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Income",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white
                                      ),
                                    ),
                                    Text(
                                      "₹${getTotalIncome()}",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 25,
                                  height: 25,
                                  decoration: const BoxDecoration(
                                      color: Colors.white30,
                                      shape: BoxShape.circle
                                  ),
                                  child: const Center(
                                      child: Icon(
                                        CupertinoIcons.arrow_down,
                                        color: Colors.red,
                                        size: 12,
                                      )
                                  ),
                                ),
                                const SizedBox(width: 8,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Expenses",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white
                                      ),
                                    ),
                                    Text(
                                      "₹${getTotalExpenses().toString()}",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Transactions",
                      style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.bold,
                      )
                    )
                  ],
                ),
                const SizedBox(height: 20,),
                Expanded(
                  child: ListView.builder(
                    itemCount: sortedExpenses.length,
                    itemBuilder: (context, int i) {
                      final deleteExpenseBloc = context.read<DeleteExpenseBloc>();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.edit, color: Colors.deepPurple),
                                        title: const Text(
                                          "Edit",
                                          style: TextStyle(
                                            fontSize: 20
                                          ),
                                        ),
                                        onTap: () async {
                                          Navigator.pop(context);
                                          var editedExpense = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  BlocProvider(
                                                      create: (context) => UpdateExpenseBloc(FirebaseExpenseRepo()),
                                                      child: EditExpense(expense: sortedExpenses[i], categories: widget.categories)
                                                  ),
                                            )
                                          );
                                          if(editedExpense != null) {
                                            setState(() {
                                              sortedExpenses[i] = editedExpense;
                                            });
                                          }
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.delete, color: Colors.red),
                                        title: const Text(
                                          "Delete",
                                          style: TextStyle(
                                              fontSize: 20
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                          getDeleteExpense(context, deleteExpenseBloc, sortedExpenses[i].expenseId);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: categoryMap[sortedExpenses[i].categoryId]?.type == 'Income'
                                    ? Colors.green
                                    : Colors.red
                              )
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Color(
                                                  int.parse(
                                                    categoryMap[sortedExpenses[i].categoryId]!.color.split('(0x')[1].split(')')[0],
                                                    radix: 16,
                                                  )
                                              ),
                                              shape: BoxShape.circle
                                            ),
                                          ),
                                          Icon(
                                            iconOptions[categoryMap[sortedExpenses[i].categoryId]!.icon],
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                      const SizedBox(width: 12,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            categoryMap[sortedExpenses[i].categoryId]!.name,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context).colorScheme.onBackground,
                                              fontWeight: FontWeight.w600,
                                            )
                                          ),
                                          Text(
                                            sortedExpenses[i].remarks,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context).colorScheme.outline,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "${categoryMap[sortedExpenses[i].categoryId]?.type == 'Income' ? "+" : "-"} ₹${sortedExpenses[i].amount.toString()}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context).colorScheme.onBackground,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('dd/MM/yyyy').format(sortedExpenses[i].date) == DateFormat('dd/MM/yyyy').format(DateTime.now())
                                            ? "Today"
                                            : DateFormat('dd/MM/yyyy').format(sortedExpenses[i].date),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context).colorScheme.outline,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                  }),
                )
              ],
            ),
        ),
      ),
    );
  }
}
