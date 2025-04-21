import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker/data/data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


class CategoryPieChart extends StatefulWidget {
  final List<Category> categories;

  const CategoryPieChart(this.categories, {super.key});

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.8;

    return SizedBox(
      height: size,
      width: size,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (event, response) {
              setState(() {
                if (!event.isInterestedForInteractions || response?.touchedSection == null) {
                  touchedIndex = -1;
                } else {
                  touchedIndex = response!.touchedSection!.touchedSectionIndex;
                }
              });
            },
          ),
          borderData: FlBorderData(show: false),
          sectionsSpace: 0,
          centerSpaceRadius: 70,
          sections: _generateSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> _generateSections() {
    final total = widget.categories.fold<double>(0, (sum, cat) => sum + cat.totalExpenses,);

    if (total == 0) return [];

    return List.generate(widget.categories.length, (i) {
      final category = widget.categories[i];
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 22.0 : 20.0;
      final radius = isTouched ? 110.0 : 100.0;

      final percent = (category.totalExpenses / total) * 100;

      return PieChartSectionData(
        color: Color(
          int.parse(
            category.color.split('(0x')[1].split(')')[0],
            radix: 16,
          ),
        ),
        value: category.totalExpenses,
        title: '${percent.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
        ),
        badgeWidget: Stack(
          alignment: Alignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black
                  )
                ),
              ),
              Icon(iconOptions[category.icon])
            ]
        ),
        badgePositionPercentageOffset: .98,
        borderSide: const BorderSide(color: Colors.black),
      );
    });
  }
}