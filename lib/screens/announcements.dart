import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/controllers/downloader.dart';
import 'package:saint_schoolparent_pro/controllers/postlist%20_controller.dart';
import 'package:saint_schoolparent_pro/models/helper%20models/download_task.dart';
import 'package:saint_schoolparent_pro/theme.dart';

import '../models/post.dart';

class PostList extends StatelessWidget {
  const PostList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Alerts'),
          bottom: const TabBar(tabs: [Tab(text: 'Announcement'), Tab(text: 'Messages')]),
        ),
        body: GetBuilder(
          init: announcementListController,
          builder: (controller) {
            return TabBarView(
              children: [
                ListView.builder(
                    itemCount: announcementListController.posts.length,
                    itemBuilder: (context, index) {
                      Post post = announcementListController.posts[index];
                      return PostTile(post: post);
                    }),
                ListView.builder(
                    itemCount: announcementListController.personalPosts.length,
                    itemBuilder: (context, index) {
                      Post post = announcementListController.personalPosts[index];
                      return PostTile(post: post);
                    }),
              ],
            );
          },
        ),
      ),
    );
  }
}

class PostTile extends StatefulWidget {
  const PostTile({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  @override
  void initState() {
    super.initState();
    FlutterDownloader.registerCallback(downloadCallback);
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((downloadData) {
      if (downloadData is TaskDownload) {
        for (int i = 0; i < taskId.length; i++) {
          var task = taskId[i];
          if (task.id == downloadData.id) {
            taskId[i] = task;
          }
        }
      }
      printInfo(info: "I am running");
      setState(() {});
    });
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  final ReceivePort _port = ReceivePort();

  @pragma('vm:entry-point')
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    if (kDebugMode) {
      print('Task => ($id) ($status) ($progress)');
    }
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send(TaskDownload(id: id, status: status, progress: progress));
  }

  List<TaskDownload> taskId = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.arrow_drop_down_circle),
            title: Text(widget.post.title),
            subtitle: Text(
              format.format(widget.post.date),
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.post.contentImage != null
                ? Image.network(
                    widget.post.contentImage!,
                    // loadingBuilder: ((context, child, loadingProgress) {
                    //   return const AspectRatio(
                    //     aspectRatio: 16 / 9,
                    //     child: Card(
                    //       child: Center(
                    //           child: CircularProgressIndicator(
                    //               // value: ((loadingProgress?.cumulativeBytesLoaded ?? 0) / (loadingProgress?.expectedTotalBytes ?? 1)),
                    //               )),
                    //     ),
                    //   );
                    // }),
                  )
                : Container(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.post.content,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          // Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: getDownloadBar(),
          // ),
          widget.post.attachments.isEmpty
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonBar(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.attachment),
                          Text(widget.post.attachments.length.toString()),
                          TextButton(
                            onPressed: () {
                              List<Future> futures = [];
                              for (var element in widget.post.attachments) {
                                futures.add(Downloader.requestDownload(element.url, element.name).then((value) {
                                  if (value != null) {
                                    taskId.add(TaskDownload(id: value, progress: 0, status: DownloadTaskStatus.enqueued));
                                  }
                                }));
                              }
                              Future.wait(futures).then((value) {
                                setState(() {});
                              });
                            },
                            child: const Text("Download"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  getDownloadBar() {
    List<Widget> returnItems = [];

    for (var task in taskId) {
      if (task.status == DownloadTaskStatus.enqueued) {
        returnItems.add(const LinearProgressIndicator());
      } else if (task.status == DownloadTaskStatus.failed) {
        returnItems.add(const LinearProgressIndicator(color: Colors.red, value: 1));
      } else if (task.status == DownloadTaskStatus.complete) {
        returnItems.add(Container());
      } else if (task.status == DownloadTaskStatus.running) {
        returnItems.add(LinearProgressIndicator(
          value: ((task.progress ?? 0).toDouble() / 100),
        ));
      } else {
        returnItems.add(const LinearProgressIndicator(
          color: Colors.yellow,
        ));
      }
    }
    return returnItems;
  }
}
