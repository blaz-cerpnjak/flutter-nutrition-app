import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nutrition_app/models/meal/meal.dart';
import 'package:nutrition_app/models/meal_type/meal_type.dart';
import 'package:nutrition_app/models/water/water.dart';
import 'package:nutrition_app/providers/preferences.dart';
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
  Hive.registerAdapter(WaterAdapter());

  await Hive.openBox<MealType>('mealTypesBox');
  await Hive.openBox<Meal>('mealsBox');
  await Hive.openBox<Food>('foodsBox');
  await Hive.openBox<Water>('watersBox');

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
          ChangeNotifierProvider(create: (context) => Preferences()),
        ],
        builder: (context, child) {
          return context.watch<Preferences>().doneLoading
              ? MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Nutrition App',
                  theme: lightTheme,
                  darkTheme: darkTheme,
                  themeMode: context.watch<ThemeManager>().themeMode,
                  home: const MainScreen(),
                )
              : LoadingScreen();
        });
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  
  @override
  void initState() {
    super.initState();
    delay();
  }

  Future<void> delay() async {
    await Future.delayed(const Duration(seconds: 2));
    context.read<Preferences>().setDoneLoading(true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(color: Colors.green),
              SizedBox(height: 20),
              Text('Getting magic ready...'),
            ],
          )
        ),
      )
    );
  }
}
