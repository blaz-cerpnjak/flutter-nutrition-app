import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nutrition_app/models/meal/meal.dart';
import 'package:nutrition_app/models/meal_type/meal_type.dart';
import 'package:nutrition_app/screens/main_screen.dart';
import 'package:nutrition_app/theme/theme_constants.dart';
import 'package:nutrition_app/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'models/food/food.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(MealTypeAdapter());
  Hive.registerAdapter(MealAdapter());
  Hive.registerAdapter(FoodAdapter());
  
  await Hive.openBox<MealType>('mealTypesBox');
  await Hive.openBox<Meal>('mealsBox');
  await Hive.openBox<Food>('foodsBox');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _MyAppState();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeManager()),
      ],
      builder: (context, child) { 
        return MaterialApp(
          title: 'Nutrition App',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: context.watch<ThemeManager>().themeMode,
          home: const MainScreen(),
        );
      }
    );
  }
}
