import 'package:hive/hive.dart';

import '../models/food/food.dart';

class Boxes {
  static Box<Food> getFoodsBox() => Hive.box<Food>("foodsBox");

}