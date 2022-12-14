import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static const String favs = 'favourites';
  static const String initScheduleState = 'initScheduleState';
  static const String scheduleSequence = 'scheduleSequence';

  static Future<List<int>> getFavs() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(favs)) {
      List<String> list = prefs.getStringList(favs) ?? [];
      return list.map((e) => int.parse(e)).toList();
    }
    return [];
  }

  static Future<void> addToFavs(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list;
    if (prefs.containsKey(favs)) {
      list = prefs.getStringList(favs) ?? [];
    } else {
      list = [];
    }
    list.add('$index');
    prefs.setStringList(favs, list);
  }

  static Future<void> removeFromFavs(int index) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(favs)) {
      List<String> list = prefs.getStringList(favs) ?? [];
      if (list.contains('$index')) {
        list.remove('$index');
      }
      prefs.setStringList(favs, list);
    }
  }

  static Future<void> saveInitScheduleState(int state) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(initScheduleState, state);
  }

  static Future<void> saveScheduleSequence(List<int> seq) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(scheduleSequence, seq.map((e) => '$e').toList());
  }

  static Future<int> getInitScheduleState() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(initScheduleState)) {
      return prefs.getInt(initScheduleState) ?? 1;
    }
    return 1;
  }

  static Future<List<int>> getScheduleSeq() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(scheduleSequence)) {
      List<String> list = prefs.getStringList(scheduleSequence) ?? ['-1', '0', '1'];
      return list.map((e) => int.parse(e)).toList();
    }
    return [-1, 0, 1];
  }
}
