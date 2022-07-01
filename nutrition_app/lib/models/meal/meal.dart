import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:nutrition_app/models/food/food.dart';
import 'package:nutrition_app/models/meal_type/meal_type.dart';
part 'meal.g.dart';

@HiveType(typeId: 2)
class Meal extends HiveObject {

  Meal({
    required this.id,
    required this.foods, 
    required this.dateTime,
    required this.mealType,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  HiveList<Food> foods;

  @HiveField(2)
  DateTime dateTime;

  @HiveField(3)
  MealType mealType;

  @override
  String toString() {
    return '$mealType, $dateTime: $foods';
  }
}