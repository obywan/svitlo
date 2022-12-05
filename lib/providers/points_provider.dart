import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:svitlo/helpers/api_request_helper.dart';
import 'package:svitlo/models/point_item.dart';
import 'package:flutter/services.dart' show rootBundle;

class PointsProvider with ChangeNotifier {
  List<PointItem> _points = [];
  List<PointItem> get points => [..._points];

  Future<List<PointItem>> getchAndSet() async {
    debugPrint('Points request!!!');
    // final result = await ApiRequestsHelper.requestGET(apiMethod: '/points');
    final testText = await _loadAsset('assets/files/test_points.txt');
    final result = ServerResponse(true, testText);
    if (result.success) {
      final data = result.body;
      _points = List<PointItem>.from((jsonDecode(data) as Iterable).map((e) => PointItem.fromJson(e)));
      // debugPrint('${_points.length}');
      moveToTop(10435);
    } else {
      // debugPrint('Failed: ${result.body}');
    }
    return _points;
  }

  Future<String> _loadAsset(String asset) async {
    // return await DefaultAssetBundle.of(context).loadString('assets/text/tac.txt');
    return await rootBundle.loadString(asset);
  }

  void moveToTop(int hostIndex) {
    final pointItem = _points.singleWhere((element) => element.hostId == hostIndex);
    _points.removeWhere((element) => element.hostId == hostIndex);
    _points.insert(0, pointItem);
  }
}
