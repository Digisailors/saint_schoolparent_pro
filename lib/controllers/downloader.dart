import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:saint_schoolparent_pro/models/result.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: depend_on_referenced_packages

class Downloader {
  static Future<String?> requestDownload(String url, String name) async {
    String? taskId;
    final saveDir = Platform.isAndroid
        ? Directory("/storage/emulated/0/Download")
        : await path.getApplicationDocumentsDirectory();
    return saveDir.create().then((value) async {
      bool isDuplicate;
      do {
        File _file = File("${saveDir.path}${Platform.pathSeparator}$name");
        isDuplicate = _file.existsSync();
        if (isDuplicate) {
          name = "$name(1)";
        }
      } while (isDuplicate);

      taskId = await FlutterDownloader.enqueue(
          url: url,
          fileName: name,
          savedDir: saveDir.path,
          openFileFromNotification: true,
          showNotification: true,
          saveInPublicStorage: true);
      return taskId;
    });
  }

  static Future<void> openInBrowser(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  static Future<Result> downloadFile(String url, String fileName) async {
    HttpClient httpClient = HttpClient();
    File file;
    String filePath = '';
    String myUrl = '';
    final saveDir = Platform.isAndroid
        ? Directory("/storage/emulated/0/Download")
        : await path.getApplicationDocumentsDirectory();

    try {
      myUrl = '$url/$fileName';
      var request = await httpClient.getUrl(Uri.parse(myUrl));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);

        filePath = (Platform.isAndroid
                ? Directory("/storage/emulated/0/Download")
                : await path.getApplicationDocumentsDirectory())
            .path;
        file = File('$filePath/$fileName');
        await file.writeAsBytes(bytes);
        return Result.success("File Downloaded successfully");
      } else {
        filePath = 'Error code:${response.statusCode}';
        return Result.error("Unknown error occurred, ${filePath.toString()}");
      }
    } catch (ex) {
      print(ex.toString());
      return Result.error("Unknown error occurred, ${ex.toString()}");
    }
  }
}