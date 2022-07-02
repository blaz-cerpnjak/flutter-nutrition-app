import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:nutrition_app/models/food/food.dart';
import 'package:nutrition_app/models/meal_type/meal_type.dart';
part 'meal.g.dart';

@HiveType(typeId: 2)
class Meal extends HiveObject {

  Meal({
    required this.id,
    required this.food, 
    required this.quantity,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  Food food;

  @HiveField(2)
  double quantity;

  @override
  String toString() {
    return '$food - $quantity g';
  }
}