import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:stepcompare/api.dart';
import 'package:stepcompare/garmin_client.dart';
import 'package:stepcompare/storage.dart';

class AppModel extends ValueNotifier {
  final HealthFactory healthFactory = HealthFactory();
  final DateTime start = DateTime.now().subtract(const Duration(days: 30));
  final types = [HealthDataType.STEPS];
  final DateTime end = DateTime.now();
  bool uploading = false;
  bool _hasAccess = false;

  List<HealthDataPoint> _phoneSteps = [];

  AppModel() : super(null);

  bool get hasAccess => _hasAccess;
  List<HealthDataPoint> get phoneSteps => _phoneSteps;

  init() async {
    String? userId = await Storage.getUserId();

    if (userId == null) {
      userId = await Api().createUser();
      if (userId == null) {
        return;
      }
      await Storage.storeUserId(userId);
    } else {
      await Api().getUser(userId);
    }
  }

  giveAccess() async {
    _hasAccess = await healthFactory.requestAuthorization(types);
    notifyListeners();
  }

  getAndUploadSteps() async {
    uploading = true;
    notifyListeners();
    try {
      _phoneSteps =
          await healthFactory.getHealthDataFromTypes(start, end, types);
      notifyListeners();
    } catch (e) {
      print(e);
    }
    List<StepData> steps =
        _phoneSteps.map((e) => StepData.fromHealthDataPoint(e)).toList();
    await Api().uploadSteps(steps);
    uploading = false;
    notifyListeners();
  }

  uploadGarmin(List<GarminStep> garminSteps) async {
    uploading = true;
    notifyListeners();

    List<StepData> steps =
        garminSteps.map((e) => StepData.fromGarmin(e)).toList();
    await Api().uploadSteps(steps);
    uploading = false;
    notifyListeners();
  }
}
