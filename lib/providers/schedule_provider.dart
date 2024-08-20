import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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
    qSchedule =
        List.generate(6, (int index) => QueueSchedule(queue: index + 1));
    debugPrint('requesting TOE');
    final result = await ApiRequestsHelper.genericRequest(
        http.get(Uri.parse('https://api.toe.com.ua/api/content/idNews/71')));

    RegExp regex = RegExp(r"\d{2}:\d{2}-\d{2}:\d{2}\d+");
    RegExp dateRegex = RegExp(
        r"\d+(січня|лютого|березня|квітня|травня|червня|липня|серпня|вересня|жовтня|листопада|грудня)");

    if (result.success) {
      String htmlText = jsonDecode(result.body)['text'];
      htmlText = Bidi.stripHtmlIfNeeded(
              htmlText.substring(0, htmlText.indexOf('table')))
          .replaceAll(' ', '')
          .replaceAll('черга', '\n');
      seqDate = dateRegex.firstMatch(htmlText)!.group(0)!;

      // debugPrint(htmlText);

      Iterable<Match> matches = regex.allMatches(htmlText);
      // debugPrint('${matches.length}');
      int j = 0;
      matches.forEach((m) {

        debugPrint('$j: ${m.group(0)}');
        j++;
        updateQueue(m.group(0)!);
      });

      // List<String> rawSchedule = matches
      //     .map((m) => m.group(0)!)
      //     .toList();
      // for (final singleString in rawSchedule) {
      // debugPrint(singleString);

      //   updateQueue(singleString);
      // }
      // for (final q in qSchedule) {
      //   debugPrint('${q.hours[0].time.hour}');
      // }
      return true;
    } else {
      debugPrint('failed');
    }
    return false;
  }

  void updateQueue(String item) {
    debugPrint(item);
    final time = item.substring(0, item.length - 1);
    debugPrint(time);
    final group = item.substring(item.length - 1, item.length);
    debugPrint(group);
    qSchedule
        .firstWhere((element) => element.queue == int.parse(group))
        .update(time);
  }
}
