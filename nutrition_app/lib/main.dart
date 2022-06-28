import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nutrition_app/models/food/food.dart';
import 'package:nutrition_app/screens/main_screen.dart';
import 'package:nutrition_app/theme/theme_constants.dart';
import 'package:nutrition_app/theme/theme_manager.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(FoodAdapter());
  await Hive.openBox<Food>('foods');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => ThemeManager(),
    builder: (context, _) {
      final themeProvier = Provider.of<ThemeManager>(context);
      return MaterialApp(
        title: 'Nutrition App',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeProvier.themeMode,
        home: const MainScreen(),
      );
    }
  );

}