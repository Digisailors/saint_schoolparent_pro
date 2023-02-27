import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/controllers/downloader.dart';

import 'package:saint_schoolparent_pro/controllers/session.dart';
import 'package:saint_schoolparent_pro/models/helper%20models/download_task.dart';
import 'package:saint_schoolparent_pro/models/result.dart';
import 'package:saint_schoolparent_pro/theme.dart';

import '../firebase.dart';
import '../models/post.dart';

class PostList extends StatelessWidget {
  PostList({Key? key, this.index = 0}) : super(key: key);

  final int index;

  // final usersQuery = FirebaseFirestore.instance.collection('users').orderBy('name');

  final Query<Map<String, dynamic>> parentsPostsRef = firestore
      .collection('posts')
      .where('audience', whereIn: [Audience.all.index, Audience.parents.index]);
  final Query<Map<String, dynamic>> postsRef = firestore
      .collection('posts')
      .where('sentTo.icNumber',
          isEqualTo: sessionController.session.parent?.icNumber);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: index,
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Alerts'),
            bottom: const TabBar(tabs: [
              Tab(text: 'General Announcement'),
              Tab(text: 'Messages')
            ]),
          ),
          body: TabBarView(
            children: [
              // FirestoreDataTable(query: postsRef, columnLabels: columnLabels),
              FirestoreListView(
                cacheExtent: 10,
                query: parentsPostsRef.orderBy('date', descending: true),
                itemBuilder: (BuildContext context,
                    QueryDocumentSnapshot<Map<String, dynamic>> doc) {
                  var post = Post.fromJson(doc.data(), doc.id);
                  return PostTile(post: post);
                },
              ),
              FirestoreListView(
                cacheExtent: 10,
                query: postsRef.orderBy('date', descending: true),
                itemBuilder: (BuildContext context,
                    QueryDocumentSnapshot<Map<String, dynamic>> doc) {
                  var post = Post.fromJson(doc.data(), doc.id);
                  return PostTile(post: post);
                },
              ),
            ],
          )),
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
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
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
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (kDebugMode) {
      print('Task => ($id) ($status) ($progress)');
    }
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
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
                ? AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      widget.post.contentImage!,
                      fit: BoxFit.contain,
                      // loadingBuilder: ((context, child, loadingProgress) {
                      //   return const Center(child: CircularProgressIndicator());
                      // }),
                    ),
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
                                futures.add(
                                  Platform.isAndroid
                                      ? Downloader.requestDownload(
                                              element.url, element.name)
                                          .then((value) {
                                          if (value != null) {
                                            taskId.add(TaskDownload(
                                                id: value,
                                                progress: 0,
                                                status: DownloadTaskStatus
                                                    .enqueued));
                                            return Result.success(
                                                "Task enqueud");
                                          }
                                        })
                                      : Downloader.downloadFile(
                                          element.url, element.name),
                                );
                              }

                              Future.wait(futures).then((results) {
                                if (results
                                    .where((element) => element.code == 'Error')
                                    .isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "The files will be downloaded. Please check notifications")));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Error occured, Files may not be downloaded")));
                                }
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
        returnItems
            .add(const LinearProgressIndicator(color: Colors.red, value: 1));
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
