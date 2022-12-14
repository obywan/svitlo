import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../helpers/api_request_helper.dart';
import '../helpers/app_settings.dart';
import '../models/point_item.dart';

class PointsProvider with ChangeNotifier {
  List<PointItem> _points = [];
  List<PointItem> get points => [..._points];
  List<int> favs = [];
  bool dataLoaded = false;

  // Map<String, String> filesToSave = {};

  bool requestInProgress = false;

  PointsProvider() {
    getchAndSet();
  }

  bool isFav(int index) {
    return favs.contains(index);
  }

  Future<void> getchAndSet() async {
    debugPrint('Points request!!!');
    final result = await ApiRequestsHelper.requestGET(apiMethod: '/static/js/points.json');
    // final testText = await _loadAsset('assets/files/test_points.txt');
    // final result = ServerResponse(true, testText);
    favs = await AppSettings.getFavs();
    if (result.success) {
      final data = result.body;
      _points = List<PointItem>.from((jsonDecode(data) as Iterable).map((e) => PointItem.fromJson(e)));
      rearrange();
      notifyListeners();
      dataLoaded = _points.fold<bool>(false, (previousValue, element) => previousValue || element.dataloaded);
    } else {
      notifyListeners();
      dataLoaded = false;
    }
    // notifyListeners();
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
