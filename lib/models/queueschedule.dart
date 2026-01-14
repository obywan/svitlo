import 'package:flutter/material.dart';

import 'power_schedule_day.dart';

class ScheduleResponse {
  final String regionId;
  final DateTime lastUpdated;
  final Fact fact;
  final Preset preset;

  ScheduleResponse({
    required this.regionId,
    required this.lastUpdated,
    required this.fact,
    required this.preset,
  });

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) {
    return ScheduleResponse(
      regionId: json['regionId'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      fact: Fact.fromJson(json['fact'] as Map<String, dynamic>),
      preset: Preset.fromJson(json['preset'] as Map<String, dynamic>),
    );
  }
}

class Fact {
  final FactData data;
  final String update;
  final int today;

  Fact({
    required this.data,
    required this.update,
    required this.today,
  });

  factory Fact.fromJson(Map<String, dynamic> json) {
    final dataMap = json['data'] as Map<String, dynamic>;

    // Get the first (and typically only) entry which contains timestamp and groups
    final entry = dataMap.entries.first;
    final timestamp = int.parse(entry.key);
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: false);

    final groupsData = entry.value as Map<String, dynamic>;
    final gpvList = <GPV>[];

    groupsData.forEach((groupName, hoursData) {
      final scheduleItems = <ScheduleItem>[];
      (hoursData as Map<String, dynamic>).forEach((hour, state) {
        int hourInt = int.parse(hour) - 1;
        int value;
        switch (state) {
          case 'no':
            value = -1;
            break;
          case 'mfirst':
          case 'msecond':
            value = 0;
            break;
          case 'yes':
            value = 1;
            break;
          default:
            value = 0;
        }
        scheduleItems.add(ScheduleItem(TimeOfDay(hour: hourInt, minute: 0), value));
      });
      gpvList.add(GPV(name: groupName.replaceAll('GPV', ''), scheduleItems: scheduleItems));
    });

    return Fact(
      data: FactData(date: date, gpvList: gpvList),
      update: json['update'] as String,
      today: json['today'] as int,
    );
  }
}

class FactData {
  final DateTime date;
  final List<GPV> gpvList;

  FactData({
    required this.date,
    required this.gpvList,
  });
}

class GPV {
  final String name;
  final List<ScheduleItem> scheduleItems;

  GPV({
    required this.name,
    required this.scheduleItems,
  });
}

class Preset {
  final Map<String, List<String>> timeZone;
  final Map<String, String> timeType;

  Preset({
    required this.timeZone,
    required this.timeType,
  });

  factory Preset.fromJson(Map<String, dynamic> json) {
    final timeZoneMap = json['time_zone'] as Map<String, dynamic>;
    final parsedTimeZone = <String, List<String>>{};

    timeZoneMap.forEach((hour, timeInfo) {
      parsedTimeZone[hour] = List<String>.from(timeInfo as List);
    });

    final timeTypeMap = json['time_type'] as Map<String, dynamic>;
    final parsedTimeType = <String, String>{};

    timeTypeMap.forEach((state, description) {
      parsedTimeType[state] = description as String;
    });

    return Preset(
      timeZone: parsedTimeZone,
      timeType: parsedTimeType,
    );
  }
}
