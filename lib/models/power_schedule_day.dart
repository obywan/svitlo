import 'dart:math';

import 'package:flutter/material.dart';

class PowerScheduleDay {
  final int day;
  final List<ScheduleItem> items;

  PowerScheduleDay({required this.items, required this.day});

  static PowerScheduleDay randomDummy(int d) {
    List<ScheduleItem> itemsSetup = [];
    for (int i = 0; i < 24; i += 3) {
      itemsSetup.add(ScheduleItem(TimeOfDay(hour: i, minute: 0), 1 - Random.secure().nextInt(3)));
    }
    return PowerScheduleDay(items: itemsSetup, day: d);
  }

  static PowerScheduleDay fromInitState(int init, int d) {
    List<ScheduleItem> itemsSetup = [];
    int state = init;
    for (int i = 0; i < 24; i += 3) {
      itemsSetup.add(ScheduleItem(TimeOfDay(hour: i, minute: 0), state));
      state = increaseStateCounter(state);
    }
    return PowerScheduleDay(items: itemsSetup, day: d);
  }

  static PowerScheduleDay fromInitStateAndSequence(int init, int d, List<int> sequence) {
    List<ScheduleItem> itemsSetup = [];
    int currentIndex = sequence.indexOf(init);
    // debugPrint('got init state $init and its index is $currentIndex');
    for (int i = 0; i < 24; i += 3) {
      itemsSetup.add(ScheduleItem(TimeOfDay(hour: i, minute: 0), sequence[currentIndex]));
      currentIndex++;
      if (currentIndex >= sequence.length) {
        currentIndex = 0;
      }
    }
    return PowerScheduleDay(items: itemsSetup, day: d);
  }

  static int increaseStateCounter(int old) {
    return (old - 1 < -1) ? 1 : old - 1;
  }

  static int getNextFromSequence(List<int> seq, int current) {
    int currentIndex = seq.indexOf(current);
    currentIndex++;
    if (currentIndex >= seq.length) {
      currentIndex = 0;
    }
    return seq[currentIndex];
  }
}

class ScheduleItem {
  final TimeOfDay time;
  // -1 — no power for sure
  // 0 — maybe no power
  // 1 — lights on!
  final int value;

  ScheduleItem(this.time, this.value);
}
