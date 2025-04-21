import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../data/data.dart';
import '../blocs/update_expense/update_expense_bloc.dart';

class EditExpense extends StatefulWidget {
  final Expense expense;
  final List<Category> categories;
  const EditExpense({required this.expense, required this.categories, super.key});

  static const IconData currency_rupee_outlined = IconData(0xf05db, fontFamily: 'MaterialIcons');

  @override
  State<EditExpense> createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {
  final TextEditingController expenseController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  bool expenseCreated = false, categoryCreated = false;
  bool isLoading = false;
  bool expanded = false;
  Category selectedCategory = Category.empty;

  @override
  void initState() {
    super.initState();
    expenseController.text = widget.expense.amount.toString();
    descriptionController.text = widget.expense.remarks;
    categoryController.text = widget.categories[widget.categories.indexWhere((element) => element.categoryId == widget.expense.categoryId)].name;
    dateController.text = DateFormat('dd/MM/yyyy').format(widget.expense.date);
    selectedCategory = widget.categories.firstWhere((element) => element.categoryId == widget.expense.categoryId);
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.expense.date,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        widget.expense.date = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateExpenseBloc, UpdateExpenseState>(
      listener: (context, state) {
        if (state is UpdateExpenseSuccess) {
          Navigator.pop(context, widget.expense);
        } else if (state is UpdateExpenseLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is UpdateExpenseFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Something went wrong")),
          );
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            title: const Text("Edit Transaction")
          ),
          body: SingleChildScrollView(
            child: Padding(
            padding: const EdgeInsets.all(23.0),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
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
                          prefixIcon: const Icon(Icons.currency_rupee_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 50,
                      child: TextFormField(
                        controller: descriptionController,
                        style: const TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Enter Remarks",
                          prefixIcon: const Icon(Icons.description),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            controller: categoryController,
                            readOnly: true,
                            onTap: () {
                              setState(() => expanded = !expanded);
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
                                      color: Color(int.parse(
                                        selectedCategory.color.split('(0x')[1].split(')')[0],
                                        radix: 16,
                                      )),
                                    ),
                                  ),
                                  Icon(iconOptions[selectedCategory.icon], size: 20),
                                ],
                              ),
                              border: expanded
                                  ? const OutlineInputBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                              )
                                  : OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                        if (expanded)
                          Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: widget.categories.isEmpty
                                  ? const Center(child: Text("No Categories"))
                                  : ListView.builder(
                                itemCount: widget.categories.length,
                                itemBuilder: (context, index) {
                                  final cat = widget.categories[index];
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        setState(() {
                                          categoryController.text = cat.name;
                                          widget.expense.categoryId = cat.categoryId;
                                          selectedCategory = cat;
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
                                              color: Color(int.parse(
                                                cat.color.split('(0x')[1].split(')')[0],
                                                radix: 16,
                                              )),
                                            ),
                                          ),
                                          Icon(iconOptions[cat.icon]),
                                        ],
                                      ),
                                      title: Text(cat.name, style: const TextStyle(fontSize: 20)),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
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
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: 150,
                      height: kToolbarHeight,
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : TextButton(
                        onPressed: () {
                          setState(() {
                            widget.expense.amount = double.tryParse(expenseController.text) ?? 0;
                            widget.expense.remarks = descriptionController.text;
                            expenseCreated = true;
                          });
                          context.read<UpdateExpenseBloc>().add(UpdateExpense(widget.expense));
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ),
      ),
    );
  }
}
