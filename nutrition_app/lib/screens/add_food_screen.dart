import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/food/food.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({Key? key}) : super(key: key);

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  late Box<Food> foodsBox;
  List<Food> foods = [];

  @override
  void initState() {
    foodsBox = Hive.box("foods");
    print(foodsBox.values);
    super.initState();
  }

  void addFood(String name, double calories, double carbs, double protein, double fats) {
    String uuid = Uuid().v4();
    Food food = Food(id: uuid, title: name, carbs: carbs, protein: protein, fats: fats, calories: calories);
    foodsBox.put(food.id, food);
  }

  void updateFood(food) {
    foodsBox.put(food.id, food);
  }

  void deleteFood(food) {
    foodsBox.delete(food.id);
  }

  void openBottomSheet(Food? food) {
    TextEditingController foodNameController = TextEditingController();
    TextEditingController caloriesController = TextEditingController();
    TextEditingController carbsController = TextEditingController();
    TextEditingController proteinController = TextEditingController();
    TextEditingController fatsController = TextEditingController();

    if (food != null) {
      foodNameController.text = food.title;
      caloriesController.text = food.calories.toString();
      carbsController.text = food.carbs.toString();
      proteinController.text = food.protein.toString();
      fatsController.text = food.fats.toString();
    }

    showModalBottomSheet(context: context, builder: (context) {
      return Container(
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
                  controller: foodNameController,
                  decoration: InputDecoration(
                    labelText: "Food name",
                    labelStyle: Theme.of(context).textTheme.bodyText1
                  ),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                TextField(
                  controller: caloriesController,
                  decoration: InputDecoration(
                    labelText: "Calories",
                    labelStyle: Theme.of(context).textTheme.bodyText1,
                  ),
                  style: Theme.of(context).textTheme.bodyText1,
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: carbsController,
                  decoration: InputDecoration(
                    labelText: "Carbs",
                    labelStyle: Theme.of(context).textTheme.bodyText1
                  ),
                  style: Theme.of(context).textTheme.bodyText1,
                  keyboardType: TextInputType.number,
                ),       
                TextField(
                  controller: proteinController,
                  decoration: InputDecoration(
                    labelText: "Protein",
                    labelStyle: Theme.of(context).textTheme.bodyText1
                  ),
                  style: Theme.of(context).textTheme.bodyText1,
                  keyboardType: TextInputType.number,
                ),     
                TextField(
                  controller: fatsController,
                  decoration: InputDecoration(
                    labelText: "Fats",
                    labelStyle: Theme.of(context).textTheme.bodyText1
                  ),
                  style: Theme.of(context).textTheme.bodyText1,
                  keyboardType: TextInputType.number,
                ),    
                ElevatedButton(
                  onPressed: () {
                    addFood(
                      foodNameController.text, 
                      double.parse(caloriesController.text),
                      double.parse(carbsController.text),
                      double.parse(proteinController.text),
                      double.parse(fatsController.text),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  child: food == null ? const Text("Add") : const Text("Update"),
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
      body: ValueListenableBuilder(
        valueListenable: foodsBox.listenable(),
        builder: (context, Box<Food> box, _) {
          List<Food> foods = box.values.toList().cast<Food>();
          foods.sort(((a, b) => a.title.toString().toLowerCase().compareTo(b.title.toString().toLowerCase())));

          return ListView.builder(
            itemCount: foods.length,
            itemBuilder: (context, index) {
              Food food = foods[index];
              return ListTile(
                title: Text(food.title),
                subtitle: Text("${food.calories} cal (P: ${food.protein}, C: ${food.carbs}, F: ${food.fats})"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_rounded),
                  onPressed: () {
                    deleteFood(food);
                  },
                ),
                onTap: () {
                  openBottomSheet(food);
                },
              );
            },
          );    
        },
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

}