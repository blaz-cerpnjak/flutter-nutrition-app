import 'package:flutter/material.dart';
import 'package:nutrition_app/widgets/info_row.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
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
                "assets/icons/nutrition_icon.png",
                Colors.green,
                0.8
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30),
              child:  InfoRow(
                "Water", 
                "3 / 8 glasses", 
                "assets/icons/water_icon.png",
                Colors.blue,
                0.4
              ),
            ),
          ],
        ),
      ),
    );
  }

}