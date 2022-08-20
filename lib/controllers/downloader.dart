import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart' as path;
// ignore: depend_on_referenced_packages

class Downloader {
  static Future<String?> requestDownload(String url, String name) async {
    String? taskId;
// final localPath =
    final saveDir = Platform.isAndroid
        ? await path.getExternalStorageDirectory()
        : await path.getApplicationDocumentsDirectory();
    return saveDir?.create().then((value) async {
      print(saveDir.path);
      taskId = await FlutterDownloader.enqueue(
        url: url,
        fileName: name,
        savedDir: saveDir.path,
        openFileFromNotification: true,
      );
      return taskId;
    });
  }
}
