import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_app/theme/theme_constants.dart';
import 'package:nutrition_app/theme/theme_manager.dart';

void main() {
  runApp(const MyApp());
}

ThemeManager _themeManager = ThemeManager();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void dispose() {
    _themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    _themeManager.addListener(themeListener);
    super.initState();
  }

  themeListener() {
    if (mounted) {
      setState(() {
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutrition App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeManager.themeMode,
      home: const MyHomePage(title: 'Nutrition App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void toggleTheme() {
    if (_themeManager.themeMode == ThemeMode.dark) {
      _themeManager.toggleTheme(false);
    } else {
      _themeManager.toggleTheme(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: 
          TextButton(
            onPressed: () { toggleTheme(); },
            child: Text("Switch theme"),
          )
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Theme.of(context).backgroundColor,
        color: Theme.of(context).bottomAppBarColor,
        items: const [
          Icon(Icons.home_rounded),
          Icon(Icons.add_rounded),
          Icon(Icons.person_rounded),
        ]
      ),
    );
  }
}
