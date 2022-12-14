import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:svitlo/models/power_schedule_day.dart';

class ScheduleProvider with ChangeNotifier {
  List<PowerScheduleDay> schedule = [];

  List<PowerScheduleDay> dummySchedule = List<PowerScheduleDay>.generate(7, (index) => PowerScheduleDay.randomDummy(index));

  ScheduleProvider() {
    fetchAndSet();
  }

  Future<void> fetchAndSet() async {
    await Future.delayed(Duration(seconds: 2));
    schedule = dummySchedule;
    debugPrint('${schedule.length}');
    notifyListeners();
  }
}
