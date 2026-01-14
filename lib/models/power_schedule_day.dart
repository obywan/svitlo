import 'package:flutter/material.dart';

class ScheduleItem {
  final TimeOfDay time;
  // -2 — no power for sure
  // -1 — maybe no power during the first half of an hour
  // 1 — maybe no power during the second half of an hour
  // 2 — lights on!
  int value;

  ScheduleItem(this.time, this.value);

  static List<ScheduleItem> scheduleFromGithub(Map<String, dynamic> json) {
    List<ScheduleItem> s = json.entries.map((e) {
      int hour = int.parse(e.key);
      int value;
      switch (e.value) {
        case 'no':
          value = -2;
          break;
        case 'mfirst':
          value = -1;
          break;
        case 'msecond':
          value = 1;
          break;
        case 'yes':
          value = 2;
          break;
        default:
          value = 0;
      }
      return ScheduleItem(TimeOfDay(hour: hour, minute: 0), value);
    }).toList();

    return s;
  }
}
