import 'package:date_format/date_format.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nutrition_app/db/Boxes.dart';
import 'package:nutrition_app/models/meal/meal.dart';
import 'package:nutrition_app/widgets/line_chart.dart';

class StatisticsScreen extends StatefulWidget {

  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {

  List<FlSpot> _spots = [];

  @override
  void initState() {
    super.initState();
    setSpots();
  }

  void setSpots() async {
    final meals = Boxes.getMealsBox().values.toList().cast<Meal>();
    final day = DateTime.now().subtract(const Duration(days: 6));
    //final List<DateTime> days = [];
    final List<double> calories = [];
    List<FlSpot> spots = [];
    final Map<String, double> dateCalories = {};

    meals.removeWhere((meal) => meal.dateTime.isBefore(day));

    for (int i = 0; i < 7; i++) {
      String date = formatDate(DateTime.now().subtract(Duration(days: i)), [dd, '-', mm, '-', yyyy]);
      //days.add(date) ;      
      dateCalories[date] = 0.0;
    }

    for (int i = 0; i < meals.length; i++) {
      Meal meal = meals[i];
      String date = formatDate(meal.dateTime.subtract(Duration(days: i)), [dd, '-', mm, '-', yyyy]);
      print(date);
      dateCalories[date] = dateCalories[date]! + ((meal.food.calories / 100) * meal.quantity);
    }

    double i = 7;
    dateCalories.forEach((datetime, calories) {
      spots.add(FlSpot(i, calories));
      i--;
    });

    setState(() {
      _spots = spots;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: MyLineChart(
            spots: _spots,
            minX: 1,
            maxX: 7,
            minY: 0,
            maxY: 2000,
            interval: 250,
          ),
        ),
      )
    );
  }

}