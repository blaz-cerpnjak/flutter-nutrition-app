import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nutrition_app/db/Boxes.dart';
import 'package:nutrition_app/models/food/food.dart';
import 'package:nutrition_app/models/meal/meal.dart';
import 'package:nutrition_app/models/meal_type/meal_type.dart';
import 'package:nutrition_app/screens/choose_food_screen.dart';
import 'package:nutrition_app/widgets/meal_info_card.dart';
import 'package:uuid/uuid.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({Key? key}) : super(key: key);

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  late Box<Meal> mealsBox;

  @override
  void initState() {
    mealsBox = Boxes.getMealsBox();
    super.initState();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
  
  void addMealType(String name) {
    final mealTypesBox = Boxes.getMealTypesBox();
    
    String uuid = const Uuid().v4();
    final MealType mealType = MealType(id: uuid, name: name, position: 0);
    
    mealTypesBox.add(mealType);
  }

  void updateMealType(MealType mealType, String name) {
    mealType.name = name;
    mealType.save();
  }

  void deleteMealType(MealType mealType) {
    mealType.delete();
  }

  void addMeal(Meal meal) {
    final mealsBox = Boxes.getMealsBox();
    mealsBox.add(meal);
  }

  void updateMeal(Meal meal) {
    meal.save();
  }

  Future<void> navigateAndAddSelection(BuildContext context) async {
    Meal? meal = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChooseFoodScreen())
    );
    if (meal != null) {
      addMeal(meal);
    }
  }

  void openBottomSheet(MealType? mealType) {
    TextEditingController mealTypeController = TextEditingController();

    if (mealType != null) {
      mealTypeController.text = mealType.name;
    }

    showModalBottomSheet(context: context, builder: (context) {
      return Container(
        height: 150,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).bottomAppBarColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            )
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
            children: <Widget> [
                TextField(
                  controller: mealTypeController,
                  decoration: InputDecoration(
                    labelText: "Meal type",
                    labelStyle: Theme.of(context).textTheme.bodyText1
                  ),
                  style: Theme.of(context).textTheme.bodyText1,
                ),  
                ElevatedButton(
                  onPressed: () {
                    if (mealType == null) {
                      addMealType(mealTypeController.text);
                    } else {
                      updateMealType(mealType, mealTypeController.text);
                    }
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  child: mealType == null ? const Text("Add") : const Text("Update"),
                ),
              ],
            ),
          ),
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ValueListenableBuilder<Box<Meal>>(
          valueListenable: Boxes.getMealsBox().listenable(), 
          builder: (context, box, _) {
            final meals = box.values.toList().cast<Meal>();
            return buildFoodList(meals);
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openBottomSheet(null);
        },
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_rounded),
      ),
    );
    
  }

  Widget buildFoodList(List<Meal> meals) {
    if (meals.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [
            const Text("No meals yet."),
            ElevatedButton(
              onPressed: () {
                navigateAndAddSelection(context);
              },
              style: ElevatedButton.styleFrom(primary: Colors.green),
              child: const Text("Add Food"),
            ),
          ],
        ),
      );
    } else {
      return ListView(
        children: [
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: meals.length,
            itemBuilder: (context, index) {
              return MealInfoCard(
                meals[index],
                () => showMealDialog(meals[index], (meal) { updateMeal(meal); })
              );
            }
          ),
          ElevatedButton(
            onPressed: () {
              navigateAndAddSelection(context);
            },
            style: ElevatedButton.styleFrom(primary: Colors.green),
            child: const Text("Add Food"),
          ),
        ],
      ); 
    }
  }

  Widget buildContent(List<MealType> mealTypes) {
    if (mealTypes.isEmpty) {
      return const Center(
        child: Text("No meals yet."),
      );
    } else {
      return ListView.builder(
        itemCount: mealTypes.length,
        itemBuilder: (context, index) {
          MealType mealType = mealTypes[index];
          return ListTile(
            title: Text(mealType.name),
            trailing: IconButton(
              icon: const Icon(Icons.delete_rounded),
              onPressed: () {
                deleteMealType(mealType);
              },
            ),
            onTap: () {
              openBottomSheet(mealType);
            },
          );
        }
      );
    }
  }

  Future<void> showMealDialog(Meal meal, onUpdateMeal) => showDialog(
    context: context,
    builder: (context) {
      final TextEditingController _quantityTextController = TextEditingController();
      _quantityTextController.text = meal.quantity.toString();

      String cals = ((meal.food.calories / 100) * meal.quantity).toStringAsFixed(2);
      String carbs = ((meal.food.carbs / 100) * meal.quantity).toStringAsFixed(2);
      String protein = ((meal.food.protein / 100) * meal.quantity).toStringAsFixed(2);
      String fats = ((meal.food.fats/ 100) * meal.quantity).toStringAsFixed(2);

      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(meal.food.title),
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
                      meal.quantity = double.parse(quantity);
                      carbs = ((meal.food.carbs / 100) * double.parse(quantity)).toStringAsFixed(2);
                      protein = ((meal.food.protein / 100) * double.parse(quantity)).toStringAsFixed(2);
                      fats = ((meal.food.fats / 100) * double.parse(quantity)).toStringAsFixed(2);
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
                onUpdateMeal(meal);
                Navigator.pop(context);
              }, 
              child: const Text("UPDATE")
            )
          ],
        ); 
      });
    }
  );

}