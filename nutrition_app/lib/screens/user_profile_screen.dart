import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
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
  late double calories;

  @override
  void initState() {
    getCalories();
    super.initState();
  }

  Future<void> getCalories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    calories = prefs.getDouble("calories") ?? 2100;
    _dailyCalsController.text = calories.toString();
  }

  void showSnackbar(BuildContext context) {
    final snackbar = SnackBar(
      content: const Text('Calories changed successfuly.'),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Daily Calories:'),
              const SizedBox(width: 150),
              Flexible(child: TextField(
                controller: _dailyCalsController,
                style: Theme.of(context).textTheme.bodyText1,
                keyboardType: TextInputType.number,
                onSubmitted: (s) {
                  context.read<Preferences>().setCalories(double.parse(s));
                  showSnackbar(context);
                },
              )),
            ],
          )
        ),
      )
    );
  }

}