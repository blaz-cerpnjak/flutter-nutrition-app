import 'package:date_picker_timeline/extra/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nutrition_app/db/Boxes.dart';
import 'package:nutrition_app/models/food/food.dart';
import 'package:nutrition_app/models/meal/meal.dart';
import 'package:nutrition_app/models/meal_type/meal_type.dart';
import 'package:nutrition_app/screens/choose_food_screen.dart';
import 'package:nutrition_app/widgets/date_row_picker.dart';
import 'package:nutrition_app/widgets/meal_info_card.dart';
import 'package:uuid/uuid.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:date_format/date_format.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({Key? key}) : super(key: key);

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  late Box<Meal> mealsBox;
  DateTime _selectedDate = DateTime.now();
  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  final DatePickerController _datePickerController = DatePickerController();

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

  void deleteMeal(Meal meal) {
    meal.delete();
  }

  List<Meal> getMeals(DateTime dateTime) {
    final mealsBox = Boxes.getMealsBox();
    final meals = mealsBox.values.toList().cast<Meal>();
    final currentDate = formatDate(dateTime, [dd, '-', mm, '-', yyyy]);
    final filteredMeals = meals.where((element) => currentDate == formatDate(element.dateTime, [dd, '-', mm, '-', yyyy])).toList();
    return filteredMeals;
  }

  Future<void> navigateAndAddSelection(BuildContext context) async {
    Meal? meal = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChooseFoodScreen())
    );
    if (meal != null) {
      meal.dateTime = _selectedDate;
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

  void incrementMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, _selectedDate.day);
      _datePickerController.animateToDate(_selectedDate);
      _startDate = DateTime(_selectedDate.year, 1, 1);
    });
  }

  void decrementMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, _selectedDate.day);
      _datePickerController.animateToDate(_selectedDate);
      _startDate = DateTime(_selectedDate.year, 1, 1); 
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
                children: <Widget>[
                  DateRowPicker(
                    date: _selectedDate,
                    onBackPressed: decrementMonth,
                    onForwardPressed: incrementMonth,
                  ),
                  DatePicker(
                    _startDate,
                    initialSelectedDate: DateTime.now(),
                    controller: _datePickerController,
                    selectionColor: Colors.green,
                    selectedTextColor: Colors.white,
                    dayTextStyle: defaultDayTextStyle.copyWith(color: Theme.of(context).primaryColor),
                    monthTextStyle: defaultMonthTextStyle.copyWith(color: Theme.of(context).primaryColor),
                    dateTextStyle: defaultDateTextStyle.copyWith(color: Theme.of(context).primaryColor),
                    onDateChange: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ValueListenableBuilder<Box<Meal>>(
                valueListenable: Boxes.getMealsBox().listenable(), 
                builder: (context, box, _) {
                  return buildFoodList(getMeals(_selectedDate));
                }
              ),
            ),
          ],
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  navigateAndAddSelection(context);
                },
                style: ElevatedButton.styleFrom(primary: Colors.green),
                child: const Text("Add Food"),
              ),
            ),
          ],
        ),
      );
    } else {
      return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: meals.length,
            itemBuilder: (context, index) {
              return  Slidable(
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        showMealDialog(meals[index], (meal) { updateMeal(meal); });
                      },
                      backgroundColor: Colors.green,
                      icon: Icons.edit_rounded,
                      label: 'Edit',
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
                    )
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        deleteMeal(meals[index]);
                      },
                      backgroundColor: Colors.red,
                      icon: Icons.delete_rounded,
                      label: 'Delete',
                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
                    ),
                  ],
                ),
                child: MealInfoCard(
                  meals[index],
                  () => showMealDialog(meals[index], (meal) { updateMeal(meal); })
                ),
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