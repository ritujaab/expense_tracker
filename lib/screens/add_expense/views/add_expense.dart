import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker/screens/add_expense/views/category_creation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../data/data.dart';
import '../blocs/create_expense/create_expense_bloc.dart';
import '../blocs/get_categories/get_categories_bloc.dart';


class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  static const IconData currency_rupee_outlined = IconData(0xf05db, fontFamily: 'MaterialIcons');

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {

  final TextEditingController typeController = TextEditingController();
  final TextEditingController expenseController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  late Expense expense;
  var newCategory = Category.empty;
  bool isLoading = false;
  Category selectedCategory = Category.empty;

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('dd/MM/yyy').format(DateTime.now());
    expense = Expense.empty;
    expense.expenseId = const Uuid().v1();
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: expense.date,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );


    if (pickedDate != null) {
      setState(() {
        dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        expense.date = pickedDate;
      });
    }
  }

  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateExpenseBloc, CreateExpenseState>(
      listener: (context, state) {
        if(state is CreateExpenseSuccess) {
          setState(() {
            expense = Expense.empty;
            selectedCategory = Category.empty;
          });
          Navigator.pop(context, [expense, newCategory]);
        } else if (state is CreateExpenseLoading) {
          setState(() {
            isLoading = true;
          });
        } else if(state is CreateExpenseFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Something went wrong"),
            )
          );
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
          ),
          body: BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
            builder: (context, state) {
              if(state is GetCategoriesSuccess) {
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Add Transaction",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 40,),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 50,
                            child: DropdownButtonFormField(
                              style: const TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Income or Expense",
                                prefixIcon: const Icon(
                                    Icons.money),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30)
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: "Income",
                                  child: Text(
                                    "Income",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: "Expense",
                                  child: Text(
                                    "Expense",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black
                                    ),
                                  )
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  typeController.text = value!;
                                  expense.type = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 16,),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 50,
                            child: TextFormField(
                              controller: expenseController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Enter Amount",
                                prefixIcon: const Icon(
                                    Icons.currency_rupee_outlined),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30)
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16,),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextFormField(
                              controller: categoryController,
                              readOnly: true,
                              onTap: () {
                                setState(() {
                                  expanded = !expanded;
                                });
                              },
                              style: const TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Category",
                                prefixIcon: selectedCategory == Category.empty
                                    ? const Icon(Icons.list)
                                    : Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: 35,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(
                                              int.parse(
                                                selectedCategory.color.split('(0x')[1].split(')')[0],
                                                radix: 16,
                                              )
                                            )
                                          )
                                        ),
                                        Icon(
                                          iconOptions[selectedCategory.icon],
                                          size: 20,
                                        )
                                      ]
                                    ),
                                suffixIcon: IconButton(
                                  onPressed: () async {
                                    newCategory = await getCategoryCreation(context);
                                    setState(() {
                                      state.categories.insert(0, newCategory);
                                    });
                                  },
                                    icon: const Icon(Icons.add)
                                ),
                                border: expanded ? const OutlineInputBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12)
                                    )
                                ) : OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30)
                                ),
                              ),
                            ),
                          ),
                          expanded
                              ? Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(12)
                              ),
                            ),
                            height: 200,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: state.categories.isEmpty ? const Center(
                                child: Text("No Categories"),
                              ):
                              ListView.builder(
                                itemCount: state.categories.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: ListTile(
                                      onTap: () {
                                        setState(() {
                                          categoryController.text = state.categories[index].name;
                                          expense.categoryId = state.categories[index].categoryId;
                                          selectedCategory = state.categories[index];
                                          expanded = false;
                                        });
                                      },
                                      leading: Stack(
                                        alignment: Alignment.center,
                                          children: [
                                            Container(
                                              width: 38,
                                              height: 38,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(
                                                  int.parse(
                                                    state.categories[index].color.split('(0x')[1].split(')')[0],
                                                    radix: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Icon(iconOptions[state.categories[index].icon])
                                          ]
                                      ),
                                      title: Text(
                                        state.categories[index].name,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12)
                                      ),
                                    ),
                                  );
                                }
                              ),
                            ),
                          ) : Container(),
                          const SizedBox(height: 16,),
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextFormField(
                                controller: dateController,
                                readOnly: true,
                                onTap: () => _pickDate(context),
                                style: const TextStyle(fontSize: 20),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: "Pick a Date",
                                  prefixIcon: const Icon(Icons.date_range),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40,),
                          SizedBox(
                            width: 150,
                            height: kToolbarHeight,
                            child: isLoading
                              ? const Center(child: CircularProgressIndicator())
                              :TextButton(
                                onPressed: () {
                                  setState(() {
                                    expense.amount = double.parse(expenseController.text);
                                    expense.type = typeController.text;
                                  });
                                  context.read<CreateExpenseBloc>().add(CreateExpense(expense));
                                },
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)
                                    )
                                ),
                                child: const Text(
                                  "Save",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22
                                  ),
                                )
                              ),
                          ),
                        ]
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}