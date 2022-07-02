import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nutrition_app/db/Boxes.dart';
import 'package:nutrition_app/models/food/food.dart';
import 'package:nutrition_app/models/meal/meal.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ChooseFoodScreen extends StatefulWidget {
  const ChooseFoodScreen({Key? key}) : super(key: key);

  @override
  State<ChooseFoodScreen> createState() => _ChooseFoodScreenState();
}

class _ChooseFoodScreenState extends State<ChooseFoodScreen> {

  void onInsertMeal(Meal meal) {
    Navigator.pop(context, meal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ValueListenableBuilder<Box<Food>>(
        valueListenable: Boxes.getFoodsBox().listenable(),
        builder: (context, box, _) {
          final foods = box.values.toList().cast<Food>();
          return buildContent(foods);
        }
      ),
    );
  }

  Widget buildContent(List<Food> foods) {
    if (foods.isEmpty) {
      return const Center(
        child: Text("No foods yet."),
      );
    } else {
      return ListView.builder(
        itemCount: foods.length,
        itemBuilder: (context, index) {
          Food food = foods[index];
          return ListTile(
            title: Text(food.title),
            subtitle: Text("${food.calories} cal (P: ${food.protein}, C: ${food.carbs}, F: ${food.fats})"),
            onTap: () async {
              await showFoodDialog(food, onInsertMeal);
              //Navigator.pop(context, food);
            },
          );
        }
      );
    }
  }

  Future<void> showFoodDialog(Food food, onInsertMeal) => showDialog(
    context: context,
    builder: (context) {
      final TextEditingController _quantityTextController = TextEditingController();
      _quantityTextController.text = "100";

      String cals = food.calories.toString();
      String carbs = food.carbs.toString();
      String protein = food.protein.toString();
      String fats = food.fats.toString();

      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(food.title),
              Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Calories (kcal):", style: Theme.of(context).textTheme.bodySmall),
                      Text("${cals}", style: Theme.of(context).textTheme.bodyText1),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Carbs (g)", style: Theme.of(context).textTheme.bodySmall),
                      Text("${carbs}", style: Theme.of(context).textTheme.bodyText1),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Protein (g)", style: Theme.of(context).textTheme.bodySmall),
                      Text("${protein}", style: Theme.of(context).textTheme.bodyText1),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Fats (g)", style: Theme.of(context).textTheme.bodySmall),
                      Text("${fats}", style: Theme.of(context).textTheme.bodyText1),
                    ],
                  ),
                ],
              ),
              TextField(
                controller: _quantityTextController,
                decoration: InputDecoration(
                  labelText: "Quantity (g)",
                  labelStyle: Theme.of(context).textTheme.bodyText1
                ),
                style: Theme.of(context).textTheme.bodyText1,
                keyboardType: TextInputType.number,
                onChanged: (quantity) {
                  setState(() {
                    cals = quantity;
                    if (quantity.isNotEmpty) {
                      carbs = ((food.carbs / 100.0) * double.parse(quantity)).toStringAsFixed(2);
                      protein = ((food.protein / 100.0) * double.parse(quantity)).toStringAsFixed(2);
                      fats = ((food.fats / 100.0) * double.parse(quantity)).toStringAsFixed(2);
                    } else {
                      cals = "?";
                      carbs = "?";
                      protein = "?";
                      fats = "?";
                    }
                  });
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final meal = Meal(
                  id: const Uuid().v4(), 
                  food: food, 
                  quantity: double.parse(_quantityTextController.text),
                  dateTime: DateTime.now()
                );
                Navigator.pop(context);
                onInsertMeal(meal);
              }, 
              child: const Text("INSERT")
            )
          ],
        ); 
      });
    }
  );
}