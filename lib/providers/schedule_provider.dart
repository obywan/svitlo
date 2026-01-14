import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:svitlo/helpers/api_request_helper.dart';
import 'package:svitlo/helpers/app_settings.dart';
import 'package:svitlo/models/queueschedule.dart';

class ScheduleProvider with ChangeNotifier {
  late ScheduleResponse? scheduleResponse;

  ScheduleProvider() {
    generateSchedule();
  }

  Future<void> fetchAndSet() async {
    await Future.delayed(Duration(seconds: 2));
    notifyListeners();
  }

  Future<void> generateSchedule() async {
    await getSchedule2();
  }

  Future<void> updateInitSchedule(int i) async {
    await AppSettings.saveInitScheduleState(i);
    await generateSchedule();
    notifyListeners();
  }

  Future<bool> getSchedule2() async {
    debugPrint('requesting Github');
    final result = await ApiRequestsHelper.genericRequest(
        http.get(Uri.parse('https://raw.githubusercontent.com/yaroslav2901/OE_OUTAGE_DATA/refs/heads/main/data/Ternopiloblenerho.json')));

    if (result.success) {
      scheduleResponse = ScheduleResponse.fromJson(jsonDecode(result.body));

      return true;
    } else {
      debugPrint('failed');
    }
    return false;
  }
}
