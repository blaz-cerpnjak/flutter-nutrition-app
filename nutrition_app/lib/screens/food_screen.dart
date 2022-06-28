import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/food/food.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({Key? key}) : super(key: key);

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  late Box<Food> foodsBox;

  @override
  void initState() {
    super.initState();
    foodsBox = Hive.box("foods");
    print(foodsBox.values);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: const Center(
        child: Text("Food Screen"),
      )
    );
    
  }

}