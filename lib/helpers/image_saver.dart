import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageSaver {
  static Future<void> logPath() async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    var filepath = path.join(documentDirectory.path, 'images');
    await Directory(filepath).create();
    debugPrint(documentDirectory.path);
  }

  static Future<void> saveImage(String url, String filename) async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    var filepath = path.join(documentDirectory.path, 'images', filename);

    File file2 = new File(filepath); // <-- 2
    bool fileExists = await file2.exists();
    if (!fileExists) {
      final response = await http.get(Uri.parse(url));
      await file2.writeAsBytes(response.bodyBytes);
    }
  }
}
