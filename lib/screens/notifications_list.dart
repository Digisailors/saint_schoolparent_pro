import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saint_schoolparent_pro/models/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  Future<List<NotificationLog>> loadData() async {
    return SharedPreferences.getInstance().then((value) {
      return value
          .getKeys()
          .map(
              (e) => NotificationLog.fromStringList(value.getStringList(e)!, e))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadData().then((value) {
      setState(() {
        logs = value;
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
                        trailing:
                            Text(DateFormat.MMMd().format(notification.time)),
                        leading: const Icon(Icons.notifications),
                      ),
                    );
                  })),
    );
  }
}
