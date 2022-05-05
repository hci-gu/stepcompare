import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:stepcompare/api.dart';
import 'package:stepcompare/garmin_client.dart';
import 'package:stepcompare/storage.dart';

class AppModel extends ValueNotifier {
  final HealthFactory healthFactory = HealthFactory();
  final DateTime start = DateTime.now().subtract(const Duration(days: 30 * 5));
  final types = [HealthDataType.STEPS];
  final DateTime end = DateTime.now();
  String userId = '';
  bool uploading = false;
  bool _hasAccess = false;
  bool phoneCompleted = false;
  bool garminCompleted = false;

  List<HealthDataPoint> _phoneSteps = [];

  AppModel() : super(null);

  bool get hasAccess => _hasAccess;
  List<HealthDataPoint> get phoneSteps => _phoneSteps;

  init() async {
    String? _userId = await Storage.getUserId();

    if (_userId == null) {
      _userId = await Api().createUser();
      if (_userId == null) {
        return;
      }
      await Storage.storeUserId(_userId);
    } else {
      _userId = await Api().getUser(_userId);
    }

    userId = _userId ?? '';

    notifyListeners();
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
    } catch (_) {}

    List<StepData> steps =
        _phoneSteps.map((e) => StepData.fromHealthDataPoint(e)).toList();
    await Api().uploadSteps(steps);
    uploading = false;
    phoneCompleted = true;
    notifyListeners();
  }

  uploadGarmin(List<GarminStep> garminSteps) async {
    uploading = true;
    notifyListeners();

    List<StepData> steps =
        garminSteps.map((e) => StepData.fromGarmin(e)).toList();
    await Api().uploadSteps(steps);
    uploading = false;
    garminCompleted = true;
    notifyListeners();
  }
}
