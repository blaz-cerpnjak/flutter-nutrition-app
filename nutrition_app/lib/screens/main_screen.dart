import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nutrition_app/screens/add_food_screen.dart';
import 'package:nutrition_app/screens/food_screen.dart';
import 'package:nutrition_app/screens/home_screen.dart';
import 'package:nutrition_app/screens/user_profile_screen.dart';
import 'package:provider/provider.dart';

import '../theme/theme_manager.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _index = 0;
  String _title = "";

  void onTap(int index) {
    setState(() {
      _index = index;
      switch(index) { 
       case 0: { _title = ''; } 
       break; 
       case 1: { _title = 'Food'; } 
       break;
       case 2: { _title = 'Add Meal'; } 
       break;
       case 3: { _title = 'Profile'; } 
       break; 
      } 
    });      
  }

  void toggleTheme(ThemeManager themeManager) {
    if (themeManager.themeMode == ThemeMode.dark) {
      themeManager.toggleTheme(false);
    } else {
      themeManager.toggleTheme(true);
    }
  }

  final List _screens = const [
    HomeScreen(),
    FoodScreen(),
    AddFoodScreen(),
    UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeManager>(context);
    bool isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        leading: IconButton(
          color: Theme.of(context).primaryColor,
          onPressed: () {},
          icon: SvgPicture.asset(
            "assets/icons/menu_icon.svg",
            color: Theme.of(context).primaryColor,
            width: 17,
          )
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _title,
              style: Theme.of(context).textTheme.subtitle1
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              toggleTheme(themeProvider);
            }, 
            icon: SvgPicture.asset(
               isDark ? "assets/icons/light_mode_icon.svg" : "assets/icons/dark_mode_icon.svg",
              color: Theme.of(context).primaryColor,
              width: 17,
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: _screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
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
              color: _index == 0 ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.5),
              width: _index == 0 ? 17 : 15,
            ),
            label: "Home"  
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/food_icon.svg",
              color: _index == 1 ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.5),
              width: _index == 1 ? 17 : 15,
            ),
            label: "Food"  
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/add_icon.svg",
              color: _index == 2 ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.5),
              width: _index == 2 ? 17 : 15,
            ),
            label: "Add"  
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/user_icon.svg",
              color: _index == 3 ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.5),
              width: _index == 3 ? 17 : 15,
            ),
            label: "User"  
          ),
        ],
      )
    );
  }

}