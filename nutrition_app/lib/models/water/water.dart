import 'package:hive/hive.dart';
part 'water.g.dart';

@HiveType(typeId: 4)
class Water extends HiveObject {
  Water({
    required this.id,
    required this.amount, 
    required this.datetime,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  double amount;

  @HiveField(2)
  DateTime datetime;

  @override
  String toString() {
    return '$datetime - $amount';
  }
}