import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:html/dom.dart';
import 'package:svitlo/helpers/api_request_helper.dart';
import 'package:svitlo/helpers/app_settings.dart';
import 'package:svitlo/models/power_schedule_day.dart';
import 'package:svitlo/models/queueschedule.dart';
// import 'package:html/parser.dart' show parse;
// import 'package:html/dom.dart';

class ScheduleProvider with ChangeNotifier {
  List<PowerScheduleDay> schedule = [];
  List<int> defaultSequence = [-1, 0, 1];
  List<int> sequence = [];
  String seqDate = '?';
  List<QueueSchedule> qSchedule = [];
      

  List<PowerScheduleDay> dummySchedule = List<PowerScheduleDay>.generate(
      7, (index) => PowerScheduleDay.randomDummy(index, 3));

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
      final result = await ApiRequestsHelper.genericRequest(http.get(Uri.parse(
          'http://threekit.3dconfiguration.com/maptest/files/seq.json')));
      if (result.success) {
        print(result.body);
        sequence = List<int>.from(jsonDecode(result.body));
      } else {
        sequence = defaultSequence;
      }
    }
    int initState = await AppSettings.getInitScheduleState();
    for (int i = 0; i < 7; i++) {
      // debugPrint('init state is $initState');
      schedule.add(
          PowerScheduleDay.fromInitStateAndSequence(initState, i, 3, sequence));
      final lastValue = schedule.last.items.last.value;
      // debugPrint('last index $lastValue');
      initState = PowerScheduleDay.getNextFromSequence(sequence, lastValue);
    }
    await generateScheduleForOneDay();
  }

  Future<void> updateInitSchedule(int i) async {
    await AppSettings.saveInitScheduleState(i);
    await generateSchedule();
    notifyListeners();
  }

  Future<bool> generateScheduleForOneDay() async {
    qSchedule = List.generate(6, (int index) => QueueSchedule(queue: index + 1));
    debugPrint('requesting TOE');
    final result = await ApiRequestsHelper.genericRequest(
        http.get(Uri.parse('https://api.toe.com.ua/api/content/idNews/71')));

    RegExp regex = RegExp(r"\d{2}:\d{2}-\d{2}:\d{2}&nbsp;\s+\d+");

    if (result.success) {
      final String htmlText = jsonDecode(result.body)['text'];

      Iterable<Match> matches = regex.allMatches(htmlText);

      seqDate = htmlText.substring(
          htmlText.indexOf('Тернопільській області') +
              'Вимкнення електроенергії'.length -
              1,
          htmlText.indexOf(', плануються'));

      List<String> rawSchedule = matches
          .map((m) => m.group(0)!.replaceAll(RegExp(r'&nbsp;'), ''))
          .toList();
      for (final singleString in rawSchedule) {
        updateQueue(singleString);
      }
      for (final q in qSchedule) {
        debugPrint('${q.hours[0].time.hour}');
      }
      return true;
    } else {
      debugPrint('failed');
    }
    return false;
  }

  void updateQueue(String item) {
    final s = item.split(' ');
    qSchedule
        .firstWhere((element) => element.queue == int.parse(s[1]))
        .update(s[0]);
  }
}
