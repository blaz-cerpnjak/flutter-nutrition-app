import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nutrition_app/db/Boxes.dart';
import 'package:nutrition_app/models/meal/meal.dart';
import 'package:nutrition_app/providers/preferences.dart';
import 'package:nutrition_app/widgets/info_row.dart';
import 'package:provider/provider.dart';
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
    if (calories > 2100) {
      return 1.0;
    }
    return (calories / 2100);
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
            const Padding(
              padding: EdgeInsets.only(top: 30),
              child:  InfoRow(
                "Water", 
                "3 / 8 glasses", 
                "assets/icons/water_icon.png",
                Colors.blue,
                0.4
              ),
            ),
          ],
        ),
      ),
    );
  }

}