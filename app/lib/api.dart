import 'package:dio/dio.dart';
import 'package:health/health.dart';
import 'dart:io' show Platform;

import 'package:stepcompare/garmin_client.dart';

const String apiUrl = 'http://192.168.0.33:4000';

class StepData {
  final int value;
  final DateTime from;
  final DateTime to;
  final String device;

  StepData({
    required this.value,
    required this.from,
    required this.to,
    required this.device,
  });

  factory StepData.fromHealthDataPoint(HealthDataPoint healthDataPoint) {
    return StepData(
      value: healthDataPoint.value.toInt(),
      from: healthDataPoint.dateFrom,
      to: healthDataPoint.dateTo,
      device: Platform.isIOS ? 'iOS' : 'Android',
    );
  }

  factory StepData.fromGarmin(GarminStep garminStep) {
    return StepData(
      value: garminStep.steps,
      from: garminStep.startGMT,
      to: garminStep.endGMT,
      device: 'Garmin',
    );
  }

  // to json
  Map<String, dynamic> toJson() => {
        'value': value,
        'from': from.toIso8601String(),
        'to': to.toIso8601String(),
        'device': device,
      };
}

class Api {
  String _userId = '';
  Dio dio = Dio(BaseOptions(
    baseUrl: apiUrl,
    connectTimeout: 5000,
    receiveTimeout: 45000,
  ));

  Future<String?> getUser(String id) async {
    var response = await dio.get('/users/$id');

    if (response.statusCode == 200) {
      _userId = id;
      return _userId;
    }

    return null;
  }

  Future<String?> createUser() async {
    var response = await dio.post('/users');

    if (response.statusCode == 200) {
      _userId = response.data['id'];
      return _userId;
    }

    return null;
  }

  Future uploadSteps(List<StepData> steps) async {
    print('/users/$_userId/steps');
    // await dio.post(
    //   '/users/$_userId/steps',
    //   data: steps.map((step) => step.toJson()).toList(),
    // );
  }

  static final Api _instance = Api._internal();
  factory Api() {
    return _instance;
  }
  Api._internal();
}
