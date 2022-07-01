import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nutrition_app/db/Boxes.dart';
import 'package:nutrition_app/models/meal_type/meal_type.dart';
import 'package:uuid/uuid.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({Key? key}) : super(key: key);

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
  
  void addMealType(String name) {
    final mealTypesBox = Boxes.getMealTypesBox();
    
    String uuid = Uuid().v4();
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
      body: ValueListenableBuilder<Box<MealType>>(
        valueListenable: Boxes.getMealTypesBox().listenable(),
        builder: (context, box, _) {
          final mealTypes = box.values.toList().cast<MealType>();
          return buildContent(mealTypes);
        }
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

}