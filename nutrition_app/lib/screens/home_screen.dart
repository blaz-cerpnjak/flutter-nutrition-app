import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nutrition_app/db/Boxes.dart';
import 'package:nutrition_app/models/meal/meal.dart';
import 'package:nutrition_app/models/water/water.dart';
import 'package:nutrition_app/providers/preferences.dart';
import 'package:nutrition_app/widgets/info_row.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {

  List<Meal> getTodaysMeals() {
    final currentDate = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);
    final mealsBox = Boxes.getMealsBox();
    final meals = mealsBox.values.toList().cast<Meal>();
    return meals.where((meal) => currentDate == formatDate(meal.dateTime, [dd, '-', mm, '-', yyyy])).toList().cast<Meal>();
  }

  double calcTodaysCals() {
    final meals = getTodaysMeals();
    double calories = 0;
    meals.forEach((meal) {
      calories += ((meal.food.calories / 100) * meal.quantity);
    });
    return calories;
  }

  double calcNutritionPercentage() {
    double calories = calcTodaysCals();
    print(calories);
    if (calories > context.read<Preferences>().calories) {
      return 1.0;
    }
    return (calories / context.read<Preferences>().calories);
  }

  List<Water> getTodaysWater() {
    final currentDate = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);
    final watersBox = Boxes.getWaterBox();
    final waters = watersBox.values.toList().cast<Water>();
    return waters.where((water) => currentDate == formatDate(water.datetime, [dd, '-', mm, '-', yyyy])).toList().cast<Water>();
  }

  double getWaterAmount() {
    final waters = getTodaysWater();
    if (waters.length <= 0) return 0.0;
    return waters.first.amount;
  }

  double calcWaterPercentage() {
    final waterAmount = getWaterAmount();
    if (waterAmount > context.read<Preferences>().glasses) {
      return 1.0;
    }
    return (waterAmount / context.read<Preferences>().glasses);
  }

  Future<void> addWater() async {
    final watersBox = Boxes.getWaterBox();
    
    final waters = getTodaysWater();
    if (waters.length <= 0) {
      String uuid = const Uuid().v4();
      final Water water = Water(id: uuid, amount: 1, datetime: DateTime.now());
      watersBox.add(water);
    } else {
      final water = waters.first;
      water.amount += 1;
      water.save();
    }
  }

  Future<void> removeWater() async {
    final watersBox = Boxes.getWaterBox();
    
    final waters = getTodaysWater();
    if (waters.length > 0) {
      final water = waters.first;
      water.amount -= 1;
      water.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Welcome back, Blaz",
              style: Theme.of(context).textTheme.headline1
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                "Eat the right amount of food and stay hydrated through the day",
                style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontWeight: FontWeight.w300),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: ValueListenableBuilder(
                valueListenable: Boxes.getMealsBox().listenable(),
                builder: (context, box, _) {
                  return InfoRow(
                    "Nutrition", 
                    "${calcTodaysCals()} / ${context.watch<Preferences>().calories}", 
                    "assets/icons/nutrition_icon.png",
                    Colors.green,
                    calcNutritionPercentage(),
                  );
                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: ValueListenableBuilder(
                valueListenable: Boxes.getWaterBox().listenable(),
                builder: (context, box, _) => 
                  InfoRow(
                    "Water", 
                    "${getWaterAmount()} / ${context.watch<Preferences>().glasses} glasses", 
                    "assets/icons/water_icon.png",
                    Colors.blue,
                    calcWaterPercentage(),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.water_drop_rounded,
        children: [
          SpeedDialChild(
            child: Icon(Icons.remove),
            label: 'Remove',
            onTap: removeWater
          ),
          SpeedDialChild(
            child: Icon(Icons.add),
            label: 'Add',
            onTap: addWater
          ),
        ],
      ),
    );
  }

}