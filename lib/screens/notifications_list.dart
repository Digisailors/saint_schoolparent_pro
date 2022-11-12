import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:saint_schoolparent_pro/firebase.dart';
import 'package:saint_schoolparent_pro/models/notification.dart';
import 'package:saint_schoolparent_pro/models/post.dart';
import 'package:saint_schoolparent_pro/screens/announcements.dart';
import 'package:saint_schoolparent_pro/screens/appointmentlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  Future<List<NotificationLog>> loadData() async {
    return SharedPreferences.getInstance().then((value) {
      return value.getKeys().map((e) => NotificationLog.fromStringList(value.getStringList(e)!, e)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadData().then((value) {
      setState(() {
        logs = value.toList();
        logs.sort((a, b) => b.time.compareTo(a.time));
      });
    });
  }

  Future<void> refresh() async {
    logs = await loadData().then((value) {
      setState(() {});
      return value;
    });
  }

  List<NotificationLog> logs = [];

  Future<bool> clear() {
    return SharedPreferences.getInstance().then((value) {
      return value.clear().then((value) {
        setState(() {});
        return value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: const Text("Refresh")),
          IconButton(onPressed: clear, icon: const Icon(Icons.clear_all))
        ],
      ),
      body: RefreshIndicator(
          onRefresh: refresh,
          child: ((logs).isEmpty)
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("No Notificataions are there"),
                      ElevatedButton(
                          onPressed: () async {
                            (await SharedPreferences.getInstance()).reload();
                            setState(() {});
                          },
                          child: const Text("Refresh"))
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    var notification = logs[index];
                    return Card(
                      child: ListTile(
                        title: Text(notification.title),
                        subtitle: Text(notification.description),
                        trailing: Text(DateFormat.MMMd().format(notification.time)),
                        leading: const Icon(Icons.notifications),
                        onTap: () async {
                          if (notification.route != null) {
                            if (notification.route != null) {
                              if (notification.route == 'POSTS') {
                                if (notification.documentPath != null) {
                                  var post = await firestore.doc(notification.documentPath!).get().then((value) {
                                    if (value.exists) {
                                      return Post.fromJson(value.data(), value.id);
                                    } else {
                                      return null;
                                    }
                                  });
                                  if (post != null) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Scaffold(
                                            appBar: AppBar(
                                              title: Text(post.audience == Audience.single ? "MESSAGE" : "ANNOUNCEMENT"),
                                            ),
                                            body: SingleChildScrollView(child: PostTile(post: post)),
                                          );
                                        });
                                  }
                                } else {
                                  Get.to(PostList());
                                }

                                return;
                              }
                              if (notification.route == 'APPOINTMENTS') {
                                Get.to(const AppointmentList());
                                return;
                              }
                            }
                          }
                        },
                      ),
                    );
                  })),
    );
  }
}
