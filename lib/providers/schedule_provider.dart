import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:svitlo/helpers/app_settings.dart';
import 'package:svitlo/models/power_schedule_day.dart';

class ScheduleProvider with ChangeNotifier {
  List<PowerScheduleDay> schedule = [];

  List<PowerScheduleDay> dummySchedule = List<PowerScheduleDay>.generate(7, (index) => PowerScheduleDay.randomDummy(index));

  ScheduleProvider() {
    generateSchedule();
  }

  Future<void> fetchAndSet() async {
    await Future.delayed(Duration(seconds: 2));
    schedule = dummySchedule;
    debugPrint('${schedule.length}');
    notifyListeners();
  }

  Future<void> generateSchedule() async {
    schedule.clear();
    int initState = await AppSettings.getInitScheduleState();
    for (int i = 0; i < 7; i++) {
      debugPrint('added $i');
      schedule.add(PowerScheduleDay.fromInitState(initState, i));
      initState = PowerScheduleDay.increaseStateCounter(schedule.last.items.last.value);
    }
  }

  Future<void> updateInitSchedule(int i) async {
    await AppSettings.saveInitScheduleState(i);
    await generateSchedule();
    notifyListeners();
  }
}
