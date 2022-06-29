import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nutrition_app/screens/add_food_screen.dart';
import 'package:nutrition_app/screens/food_screen.dart';
import 'package:nutrition_app/screens/home_screen.dart';
import 'package:nutrition_app/screens/user_profile_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/theme_manager.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _index = 0;
  String _title = "";
  bool _isDark = false;
  PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  @override
  void initState() {
    getTheme();
    super.initState();
  }

  Future<void> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool("isDark") ?? false;
  }

  Future<void> saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDark", _isDark);
  }

  void onItemSelected(int index) {
    setState(() {
      _index = index;
      switch(index) { 
       case 0: { _title = ''; } 
       break; 
       case 1: { _title = 'Food'; } 
       break;
       case 2: { _title = 'Add Food'; } 
       break;
       case 3: { _title = 'Profile'; } 
       break; 
      } 
    });
  }

  void toggleTheme(ThemeManager themeManager) {
    if (themeManager.themeMode == ThemeMode.dark) {
      themeManager.toggleTheme(false);
      _isDark = false;
    } else {
      themeManager.toggleTheme(true);
      _isDark = true;
    }
  }

  final List<Widget> _screens = const [
    HomeScreen(),
    FoodScreen(),
    AddFoodScreen(),
    UserProfileScreen(),
  ];

  
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
        PersistentBottomNavBarItem(
            icon: SvgPicture.asset(
              "assets/icons/home_icon.svg",
              color: _controller.index == 0 ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.5),
              width: 15,
            ),
            title: ("Home"),
            activeColorPrimary: Theme.of(context).primaryColor,
            inactiveColorPrimary: Colors.grey.withOpacity(0.5),
        ),
        PersistentBottomNavBarItem(
            icon: SvgPicture.asset(
              "assets/icons/food_icon.svg",
              color: _controller.index == 1 ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.5),
              width: 15,
            ),
            title: ("Foods"),
            activeColorPrimary: Theme.of(context).primaryColor,
            inactiveColorPrimary: Colors.grey.withOpacity(0.5),
        ),
        PersistentBottomNavBarItem(
            icon: SvgPicture.asset(
              "assets/icons/add_icon.svg",
              color: _controller.index == 2 ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.5),              
              width: 15,
            ),
            title: ("Add Food"),
            activeColorPrimary: Theme.of(context).primaryColor,
            inactiveColorPrimary: Colors.grey.withOpacity(0.5),
        ),
        PersistentBottomNavBarItem(
            icon: SvgPicture.asset(
              "assets/icons/user_icon.svg",
              color: _controller.index == 3 ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.5),
              width: 15,
            ),
            title: ("Profile"),
            activeColorPrimary: Theme.of(context).primaryColor,
            inactiveColorPrimary: Colors.grey.withOpacity(0.5),
        ),
    ];
  }

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
              _isDark ? "assets/icons/light_mode_icon.svg" : "assets/icons/dark_mode_icon.svg",
              color: Theme.of(context).primaryColor,
              width: 17,
            ),
          ),
        ],
      ),
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _screens,
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Theme.of(context).bottomAppBarColor,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true, 
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Theme.of(context).bottomAppBarColor,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style12,
        onItemSelected: (index) {
          onItemSelected(index);
        },
      ),
    );
  }

}