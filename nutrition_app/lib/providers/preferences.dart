import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences with ChangeNotifier {

  SharedPreferences? _preferences;
  double _calories = 2000.0;
  bool _doneLoading = false;

  double get calories => _calories;
  bool get doneLoading => _doneLoading;

  Preferences() {
    _loadFromPrefs();
  }

  setCalories(double calories) {
    _calories = calories;
    _saveToPrefs();
    notifyListeners();
  }

  setDoneLoading(bool value) {
    _doneLoading = value;
    notifyListeners();
  }

  _initPrefs() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _calories = _preferences?.getDouble('calories') ?? 2000.0;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _preferences?.setDouble('calories', _calories);
  }

}