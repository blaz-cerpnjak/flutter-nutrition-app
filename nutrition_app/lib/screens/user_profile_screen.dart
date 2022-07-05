import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nutrition_app/extensions/string_extensions.dart';
import 'package:nutrition_app/providers/preferences.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);
  
  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController _dailyCalsController = TextEditingController();
  final TextEditingController _dailyWaterIntakeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  late double calories;
  late double waterIntake;
  late String name;

  @override
  void initState() {
    setData();
    super.initState();
  }

  Future<void> setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    calories = prefs.getDouble("calories") ?? 2100;
    waterIntake = prefs.getDouble("waterAmount") ?? 3.0;
    name = prefs.getString('username') ?? '?';

    _dailyCalsController.text = calories.toString();
    _dailyWaterIntakeController.text = waterIntake.toString();
    _nameController.text = name.toString();
  }

  void showSnackbar(BuildContext context, String text) {
    final snackbar = SnackBar(
      content: Text(text),
      action: SnackBarAction(label: 'OK', onPressed: () {}),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Name:',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _nameController,
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(border: InputBorder.none),
                      onSubmitted: (s) {
                        context.read<Preferences>().setUsername(s);
                        showSnackbar(context, 'Success');
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daily Calories:',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _dailyCalsController,
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(border: InputBorder.none),
                      keyboardType: TextInputType.number,
                      onSubmitted: (s) {
                        if (s.isValidDouble()) {
                          context.read<Preferences>().setCalories(double.parse(s));
                          showSnackbar(context, 'Success');
                        } else {
                          showSnackbar(context, 'Your input is not a valid number.');
                        }
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daily water intake:',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _dailyWaterIntakeController,
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(border: InputBorder.none),
                      keyboardType: TextInputType.number,
                      onSubmitted: (s) {
                        if (s.isValidDouble()) {
                          context.read<Preferences>().setWaterAmount(double.parse(s));
                          showSnackbar(context, 'Success.');
                        } else {
                          showSnackbar(context, 'Your input is not a valid number.');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          )
        ),
      )
    );
  }

}