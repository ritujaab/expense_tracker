import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker/screens/add_expense/views/category_creation.dart';
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
  final TextEditingController expenseController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  late Expense expense;
  bool expenseCreated = false, categoryCreated = false;
  bool isLoading = false;
  bool expanded = false;
  Category selectedCategory = Category.empty;

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateExpenseBloc, CreateExpenseState>(
      listener: (context, state) {
        if (state is CreateExpenseSuccess) {
          setState(() {
            expense = Expense.empty;
            selectedCategory = Category.empty;
          });
          Navigator.pop(context, [expenseCreated, categoryCreated]);
        } else if (state is CreateExpenseLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is CreateExpenseFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Something went wrong")),
          );
        }
      },
      child: WillPopScope(
        onWillPop:  () async {
          Navigator.pop(context, [expenseCreated, categoryCreated]);
          return false;
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.background,
                title: const Text("Add Transaction"),
                bottom: const TabBar(
                  tabs: [
                    Tab(text: "Expense"),
                    Tab(text: "Income"),
                  ],
                  labelStyle: TextStyle(fontSize: 20),
                ),
              ),
              body: BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
                builder: (context, state) {
                  if (state is GetCategoriesSuccess) {
                    return TabBarView(
                      children: [
                        _buildTabContent(context, state.categories, "Expense"),
                        _buildTabContent(context, state.categories, "Income"),
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, List<Category> allCategories, String type) {
    final filteredCategories = allCategories.where((cat) => cat.type == type).toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
            _buildCategorySelector(context, filteredCategories, type),
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
                    expense.amount = double.tryParse(expenseController.text) ?? 0;
                    expense.remarks = descriptionController.text;
                    expenseCreated = true;
                  });
                  context.read<CreateExpenseBloc>().add(CreateExpense(expense));
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
    );
  }

  Widget _buildCategorySelector(BuildContext context, List<Category> categories, String type) {
    return Column(
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
              suffixIcon: IconButton(
                onPressed: () async {
                  await getCategoryCreation(context, type);
                  categoryCreated = true;
                  setState(() {
                    context.read<GetCategoriesBloc>().add(GetCategories());
                  });
                },
                icon: const Icon(Icons.add),
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
              child: categories.isEmpty
                  ? const Center(child: Text("No Categories"))
                  : ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          categoryController.text = cat.name;
                          expense.categoryId = cat.categoryId;
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
    );
  }
}
