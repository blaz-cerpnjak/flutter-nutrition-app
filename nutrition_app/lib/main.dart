import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nutrition_app/screens/main_screen.dart';
import 'package:nutrition_app/theme/theme_constants.dart';
import 'package:nutrition_app/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'models/food/food.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(FoodAdapter());
  await Hive.openBox<Food>('foodsBox');

  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  _MyAppState();

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
            home: MainScreen(),
          );
      });
}
