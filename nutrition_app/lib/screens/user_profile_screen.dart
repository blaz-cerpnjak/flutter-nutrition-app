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
  final TextEditingController _watersStepController = TextEditingController();

  late double calories;
  late double waterIntake;
  late String name;
  late double waterStep;

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
    waterStep = prefs.getDouble('waterStep') ?? 0.250;

    _dailyCalsController.text = calories.toString();
    _dailyWaterIntakeController.text = waterIntake.toString();
    _nameController.text = name.toString();
    _watersStepController.text = waterStep.toString();
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
              prefsItem(
                title: 'Name', 
                onSave: (s) {
                  context.read<Preferences>().setUsername(s);
                  showSnackbar(context, 'Success');
                },
                controller: _nameController
              ),
              prefsItem(
                title: 'Daily calories', 
                onSave: (s) {
                  if (s.isValidDouble()) {
                    context
                      .read<Preferences>()
                      .setCalories(double.parse(s));
                    showSnackbar(context, 'Success');
                  } else {
                    showSnackbar(context, 'Your input is not a valid number.');
                  }
                }, 
                controller: _dailyCalsController,
                isNumber: true,
              ),
              prefsItem(
                title: 'Daily water intake',
                onSave: (s) {
                  if (s.isValidDouble()) {
                    context
                      .read<Preferences>()
                      .setWaterAmount(double.parse(s));
                    showSnackbar(context, 'Success.');
                  } else {
                    showSnackbar(context, 'Your input is not a valid number.');
                  }
                },
                controller: _dailyWaterIntakeController,
                isNumber: true,
              ),
              prefsItem(
                title: 'Water step', 
                onSave: (s) {
                  if (s.isValidDouble()) {
                    context
                      .read<Preferences>()
                      .setWaterStep(double.parse(s));
                    showSnackbar(context, 'Success.');
                  } else {
                    showSnackbar(context, 'Your input is not a valid number.');
                  }
                },
                controller: _watersStepController,
              ),
            ],
          )),
        ));
  }

  Widget prefsItem({
    required String title,
    required Function(String) onSave,
    required TextEditingController controller,
    bool? isNumber = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        SizedBox(
          width: 100,
          child: TextField(
            controller: controller,
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(border: InputBorder.none),
            keyboardType:
                isNumber == true ? TextInputType.number : TextInputType.text,
            onSubmitted: onSave,
          ),
        ),
      ],
    );
  }
}
