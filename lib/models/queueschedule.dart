import 'package:flutter/material.dart';
import 'power_schedule_day.dart';

class QueueSchedule {
  final int queue;
  List<ScheduleItem> hours = List.generate(24, (int index)=> ScheduleItem(TimeOfDay(hour: index, minute: 0), 1));

  QueueSchedule({required this.queue});

  void update(String span){
    final hh = span.split('-');
    final hs = int.parse(hh[0].split(':')[0]);
    final he = int.parse(hh[1].split(':')[0]);
    for(int i = hs; i < he; i++){
      hours[i].value = -1;
    }
  }

}