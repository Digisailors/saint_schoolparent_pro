import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
// ignore: depend_on_referenced_packages

class Downloader {
  static Future<String?> requestDownload(String url, String name) async {
    String? taskId;
    String localPath = '/storage/emulated/0/Download/';
    final saveDir = Directory(localPath);
    return saveDir.create().then((value) async {
      taskId = await FlutterDownloader.enqueue(
        url: url,
        fileName: name,
        savedDir: localPath,
        openFileFromNotification: true,
      );
      return taskId;
    });
  }
}
