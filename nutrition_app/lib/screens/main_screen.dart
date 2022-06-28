import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nutrition_app/screens/add_food_screen.dart';
import 'package:nutrition_app/screens/food_screen.dart';
import 'package:nutrition_app/screens/home_screen.dart';
import 'package:nutrition_app/screens/user_profile_screen.dart';
import 'package:nutrition_app/theme/theme_manager.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int index = 0;

  void onTap(int newIndex) {
    setState(() {
      index = newIndex;
    });      
  }

  List screens = [
    HomeScreen(),
    FoodScreen(),
    AddFoodScreen(),
    UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
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
      body: screens[index],
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