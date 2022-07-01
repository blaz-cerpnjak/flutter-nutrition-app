import 'package:hive/hive.dart';
part 'food.g.dart';

@HiveType(typeId: 1)
class Food extends HiveObject {
  Food({
    required this.id,
    required this.title, 
    required this.carbs,
    required this.protein,
    required this.fats,
    required this.calories,
    this.fiber,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  double carbs;

  @HiveField(3)
  double protein;

  @HiveField(4)
  double fats;

  @HiveField(5)
  double calories;

  @HiveField(6)
  double? fiber;

  @override
  String toString() {
    return '$title: C:$carbs, P:$protein, F:$fats';
  }
}