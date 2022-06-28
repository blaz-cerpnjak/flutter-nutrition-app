import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nutrition_app/theme/theme_manager.dart';
import 'package:nutrition_app/widgets/info_row.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Welcome back, Blaz",
              style: Theme.of(context).textTheme.headline1
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                "Eat the right amount of food and stay hydrated through the day",
                style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontWeight: FontWeight.w300),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 50),
              child: InfoRow(
                "Nutrition", 
                "1000 cal / 2100 cal", 
                "assets/icons/nutrition_icon.png"
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30),
              child:  InfoRow(
                "Water", 
                "3 / 8 glasses", 
                "assets/icons/water_icon.png"
              ),
            ),
          ],
        ),
      ),
    );
      /*Center(
        child: 
          TextButton(
            onPressed: () { toggleTheme(themeProvider); },
            child: const Text("Switch theme"),
          )
      )
    );*/
    
  }
}