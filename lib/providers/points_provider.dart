import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:svitlo/helpers/api_request_helper.dart';
import 'package:svitlo/helpers/app_settings.dart';
import 'package:svitlo/models/point_item.dart';
import 'package:flutter/services.dart' show rootBundle;

class PointsProvider with ChangeNotifier {
  List<PointItem> _points = [];
  List<PointItem> get points => [..._points];
  List<int> favs = [];

  bool requestInProgress = false;

  PointsProvider() {
    getchAndSet();
  }

  bool isFav(int index) {
    return favs.contains(index);
  }

  Future<void> getchAndSet() async {
    debugPrint('Points request!!!');
    final result = await ApiRequestsHelper.requestGET(apiMethod: '/points');
    // final testText = await _loadAsset('assets/files/test_points.txt');
    // final result = ServerResponse(true, testText);
    favs = await AppSettings.getFavs();
    if (result.success) {
      final data = result.body;
      _points = List<PointItem>.from((jsonDecode(data) as Iterable).map((e) => PointItem.fromJson(e)));
      rearrange();
    } else {
      // debugPrint('Failed: ${result.body}');
    }
    notifyListeners();
  }

  Future<String> _loadAsset(String asset) async {
    // return await DefaultAssetBundle.of(context).loadString('assets/text/tac.txt');
    return await rootBundle.loadString(asset);
  }

  Future<void> favTap(int index) async {
    if (favs.contains(index)) {
      favs.remove(index);
      rearrange();
      notifyListeners();
      await AppSettings.removeFromFavs(index);
    } else {
      favs.add(index);
      rearrange();
      notifyListeners();
      await AppSettings.addToFavs(index);
    }
  }

  void rearrange() {
    for (int f in favs) {
      moveToTop(f);
    }
  }

  void moveToTop(int hostIndex) {
    final pointItem = _points.singleWhere((element) => element.hostId == hostIndex);
    _points.removeWhere((element) => element.hostId == hostIndex);
    _points.insert(0, pointItem);
  }
}
