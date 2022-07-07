import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences with ChangeNotifier {

  SharedPreferences? _preferences;

  double _calories = 2000.0;
  double _waterAmount = 3.0;
  bool _doneLoading = false;
  String _username = '';
  double _waterStep = 0.250;

  double get calories => _calories;
  double get waterAmount => _waterAmount;
  bool get doneLoading => _doneLoading;
  String get username => _username;
  double get waterStep => _waterStep;

  Preferences() {
    _loadFromPrefs();
  }

  setCalories(double calories) {
    _calories = calories;
    _saveToPrefs();
    notifyListeners();
  }

  setWaterAmount(double waterAmount) {
    _waterAmount = waterAmount;
    _saveToPrefs();
    notifyListeners();
  }

  setDoneLoading(bool value) {
    _doneLoading = value;
    notifyListeners();
  }

  setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  setWaterStep(double waterStep) {
    _waterStep = waterStep;
    notifyListeners();
  }

  _initPrefs() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _calories = _preferences?.getDouble('calories') ?? 2000.0;
    _waterAmount = _preferences?.getDouble('waterAmount') ?? 3.0;
    _username = _preferences?.getString('username') ?? '';
    _waterStep = _preferences?.getDouble('waterStep') ?? 0.250;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _preferences?.setDouble('calories', _calories);
    _preferences?.setDouble('waterAmount', _waterAmount);
    _preferences?.setString('username', _username);
    _preferences?.setDouble('waterStep', _waterStep);
  }

}