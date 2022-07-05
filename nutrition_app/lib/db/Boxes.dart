import 'package:hive/hive.dart';
import 'package:nutrition_app/models/meal/meal.dart';
import 'package:nutrition_app/models/meal_type/meal_type.dart';
import 'package:nutrition_app/models/water/water.dart';

import '../models/food/food.dart';

class Boxes {
  static Box<MealType> getMealTypesBox() => Hive.box<MealType>("mealTypesBox");
  static Box<Meal> getMealsBox() => Hive.box<Meal>("mealsBox");
  static Box<Food> getFoodsBox() => Hive.box<Food>("foodsBox");
  static Box<Water> getWaterBox() => Hive.box<Water>("watersBox");
}