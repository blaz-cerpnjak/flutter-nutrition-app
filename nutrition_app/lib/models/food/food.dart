import 'package:hive/hive.dart';
part 'food.g.dart';

@HiveType(typeId: 1)
class Food {
  Food({
    required this.title, 
    required this.carbs,
    required this.protein,
    required this.fats,
    required this.calories,
    this.fiber,
  });

  @HiveField(0)
  String title;

  @HiveField(1)
  double carbs;

  @HiveField(2)
  double protein;

  @HiveField(3)
  double fats;

  @HiveField(4)
  double calories;

  @HiveField(5)
  double? fiber;

  @override
  String toString() {
    return '$title: C:$carbs, P:$protein, F:$fats';
  }
}