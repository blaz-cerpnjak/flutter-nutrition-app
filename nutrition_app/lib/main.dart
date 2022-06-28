import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  int index = 0;

  void onTap(int newIndex) {
    setState(() {
      index = newIndex;
    });      
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          color: Theme.of(context).primaryColor,
          onPressed: () {},
          icon: Padding(
            padding: const EdgeInsets.all(8),
            child: SvgPicture.asset(
              "assets/icons/menu_icon.svg",
              color: Theme.of(context).primaryColor,
            )
          )
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: 
          TextButton(
            onPressed: () { toggleTheme(); },
            child: const Text("Switch theme"),
          )
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).backgroundColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).bottomAppBarColor,
        elevation: 0,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/home_icon.svg",
              color: index == 0 ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.5),
              width: index == 0 ? 17 : 15,
            ),
            label: "Home"  
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/food_icon.svg",
              color: index == 1 ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.5),
              width: index == 1 ? 17 : 15,
            ),
            label: "Food"  
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/add_icon.svg",
              color: index == 2 ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.5),
              width: index == 2 ? 17 : 15,
            ),
            label: "Add"  
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/user_icon.svg",
              color: index == 3 ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.5),
              width: index == 3 ? 17 : 15,
            ),
            label: "User"  
          ),
        ],
      )
    );
  }
}
