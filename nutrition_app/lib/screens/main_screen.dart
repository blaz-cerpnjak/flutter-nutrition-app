import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:nutrition_app/providers/preferences.dart';
import 'package:nutrition_app/screens/add_food_screen.dart';
import 'package:nutrition_app/screens/choose_food_screen.dart';
import 'package:nutrition_app/screens/food_screen.dart';
import 'package:nutrition_app/screens/home_screen.dart';
import 'package:nutrition_app/screens/settings_screen.dart';
import 'package:nutrition_app/screens/statistics_screen.dart';
import 'package:nutrition_app/screens/user_profile_screen.dart';
import 'package:nutrition_app/widgets/drawer_menu_screen.dart';
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
  final _zoomDrawerController = ZoomDrawerController();

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
      index < 4 ? _controller.index = index : null;
      _index = index;
      switch(index) { 
       case 0: { _title = ''; } break; 
       case 1: { _title = 'Food'; } break;
       case 2: { _title = 'Add Food'; } break;
       case 3: { _title = 'Profile'; } break; 
       case 4: { _title = 'Settings'; } break;
      } 
    });
  }

  final List<Widget> _screens = const [
    HomeScreen(),
    FoodScreen(),
    AddFoodScreen(),
    UserProfileScreen(),
  ];

  final List<Widget> _subScreens = const [
    HomeScreen(),
    FoodScreen(),
    AddFoodScreen(),
    UserProfileScreen(),
    SettingsScreen(),
    StatisticsScreen(),
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

    return ZoomDrawer(
      controller: _zoomDrawerController,
      style: DrawerStyle.defaultStyle,
      borderRadius: 24,
      angle: -10.0,
      showShadow: true,
      drawerShadowsBackgroundColor: Theme.of(context).backgroundColor,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      menuBackgroundColor: Colors.green,
      menuScreen: DrawerMenuScreen(
        onSelectedItem: (item) => onItemSelected(item.index),
      ),
      mainScreen: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          leading: IconButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              _zoomDrawerController.open?.call();
          },
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
                context.read<ThemeManager>().toggleTheme(_isDark);
                if (context.read<ThemeManager>().themeMode == ThemeMode.dark) {
                  context.read<ThemeManager>().toggleTheme(false);
                  _isDark = false;
                } else {
                  context.read<ThemeManager>().toggleTheme(true);
                  _isDark = true;
                }
              }, 
              icon: SvgPicture.asset(
                _isDark ? "assets/icons/light_mode_icon.svg" : "assets/icons/dark_mode_icon.svg",
                color: Theme.of(context).primaryColor,
                width: 17,
              ),
            ),
          ],
        ),
        body: _index < 4 ? PersistentTabView(
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
        ) : _subScreens[_index],
      ),
    );
  }

}