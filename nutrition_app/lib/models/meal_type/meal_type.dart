import 'package:hive/hive.dart';
import 'package:nutrition_app/models/food/food.dart';
part 'meal_type.g.dart';

@HiveType(typeId: 3)
class MealType extends HiveObject {

  MealType({
    required this.id,
    required this.name, 
    required this.position,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int position;

  @override
  String toString() {
    return name;
  }
  
}