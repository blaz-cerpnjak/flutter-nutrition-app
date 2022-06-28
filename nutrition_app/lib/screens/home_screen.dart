import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nutrition_app/theme/theme_manager.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {

  void toggleTheme(ThemeManager themeManager) {
    if (themeManager.themeMode == ThemeMode.dark) {
      themeManager.toggleTheme(false);
    } else {
      themeManager.toggleTheme(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeManager>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: 
          TextButton(
            onPressed: () { toggleTheme(themeProvider); },
            child: const Text("Switch theme"),
          )
      )
    );
    
  }
}