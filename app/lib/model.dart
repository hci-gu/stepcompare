import 'package:flutter/material.dart';
import 'package:health/health.dart';

class AppModel extends ValueNotifier {
  final HealthFactory healthFactory = HealthFactory();
  final DateTime start = DateTime.now().subtract(Duration(days: 30));
  final types = [HealthDataType.STEPS];
  final DateTime end = DateTime.now();
  bool _hasAccess = false;

  List<HealthDataPoint> _phoneSteps = [];

  AppModel() : super(null);

  bool get hasAccess => _hasAccess;
  List<HealthDataPoint> get phoneSteps => _phoneSteps;

  giveAccess() async {
    _hasAccess = await healthFactory.requestAuthorization(types);
    notifyListeners();
  }

  getSteps() async {
    try {
      _phoneSteps =
          await healthFactory.getHealthDataFromTypes(start, end, types);
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}
