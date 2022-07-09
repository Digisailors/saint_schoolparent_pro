import 'package:flutter_downloader/flutter_downloader.dart';

class TaskDownload {
  final String id;
  final DownloadTaskStatus? status;
  final int? progress;

  TaskDownload({required this.id, this.status, this.progress});
}
