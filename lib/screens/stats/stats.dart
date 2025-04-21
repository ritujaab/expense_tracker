import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker/screens/stats/pie.dart';
import 'package:flutter/material.dart';

class StatsScreen extends StatefulWidget {
  final List<Category> categories;
  const StatsScreen(this.categories, {super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            const Text(
                "Transactions",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20,),
            Center(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 30,
                    bottom: 30,
                  ),
                  child: Column(
                    children: [
                      const Text(
                          "Expenses by Category",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 20,),
                      CategoryPieChart(widget.categories.where((cat) => cat.type == 'Expense').toList()),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
