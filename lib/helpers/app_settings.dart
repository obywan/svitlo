import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static const String favs = 'favourites';

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
}
