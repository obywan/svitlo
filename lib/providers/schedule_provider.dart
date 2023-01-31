import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:svitlo/helpers/api_request_helper.dart';
import 'package:svitlo/helpers/app_settings.dart';
import 'package:svitlo/models/power_schedule_day.dart';
import 'package:http/http.dart' as http;

class ScheduleProvider with ChangeNotifier {
  List<PowerScheduleDay> schedule = [];
  List<int> defaultSequence = [-1, 0, 1];
  List<int> sequence = [];

  List<PowerScheduleDay> dummySchedule = List<PowerScheduleDay>.generate(7, (index) => PowerScheduleDay.randomDummy(index));

  // ScheduleProvider() {
  //   // generateSchedule();
  // }

  Future<void> fetchAndSet() async {
    await Future.delayed(Duration(seconds: 2));
    schedule = dummySchedule;
    debugPrint('${schedule.length}');
    notifyListeners();
  }

  Future<void> generateSchedule() async {
    schedule.clear();
    if (sequence.isEmpty) {
      final result = await ApiRequestsHelper.genericRequest(http.get(Uri.parse('http://threekit.3dconfiguration.com/maptest/files/seq.json')));
      if (result.success) {
        print(result.body);
        sequence = List<int>.from(jsonDecode(result.body));
      } else {
        sequence = defaultSequence;
      }
    }
    int initState = await AppSettings.getInitScheduleState();
    for (int i = 0; i < 7; i++) {
      debugPrint('init state is $initState');
      schedule.add(PowerScheduleDay.fromInitStateAndSequence(initState, i, sequence));
      final lastValue = schedule.last.items.last.value;
      debugPrint('last index $lastValue');
      initState = PowerScheduleDay.getNextFromSequence(sequence, lastValue);
    }
  }

  Future<void> updateInitSchedule(int i) async {
    await AppSettings.saveInitScheduleState(i);
    await generateSchedule();
    notifyListeners();
  }
}
