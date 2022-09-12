import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/controllers/parent.dart';
import 'package:saint_schoolparent_pro/controllers/postlist%20_controller.dart';
import 'package:saint_schoolparent_pro/main.dart';
import 'package:saint_schoolparent_pro/models/parent.dart';
import 'package:saint_schoolparent_pro/screens/announcements.dart';
import 'package:saint_schoolparent_pro/screens/appointmentlist.dart';
import 'package:saint_schoolparent_pro/screens/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/notification.dart';
import 'notifications_list.dart';

class BottomRouter extends StatefulWidget {
  const BottomRouter({Key? key, required this.parent}) : super(key: key);

  final Parent parent;

  @override
  State<BottomRouter> createState() => _BottomRouterState();
}

class _BottomRouterState extends State<BottomRouter> {
  int _selectedIndex = 0;
  // static const TextStyle optionStyle =
  // TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const AppointmentList(),
    const PostList(),
    const NotificationList(),
  ];

  @override
  void initState() {
    super.initState();
    loadFirebaseMessaging();
    ParentController.listenParent();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PostListController());
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.blueGrey,
        selectedItemColor: Colors.blue,
        elevation: 3,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Appointment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Announcements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
        currentIndex: _selectedIndex,
        // selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Future<void> loadDataToLocal(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    // AndroidNotification? android = message.notification?.android;RemoteNotification? notification = message.notification;
    // AndroidNotification? android = message.notification?.android;
    print("Load Data TO LOCAL Loaded");
    if (notification != null) {
      try {
        var prefs = await SharedPreferences.getInstance().catchError((error) {
          printError();
        });

        var notificationLog = NotificationLog(
            messageId: DateTime.now().millisecondsSinceEpoch.toString(),
            description: notification.body ?? message.data['body'],
            title: notification.title ?? '',
            time: DateTime.now(),
            route: message.data['route'] ?? '');
        var result = prefs.setStringList(message.messageId!, notificationLog.toStringList());
        if (kDebugMode) {
          print(result);
        }
      } catch (e) {
        if (kDebugMode) {
          printError(info: 'Error occured!!');
          print(e.toString());
        }
      }
      if (Platform.isAndroid) {
        await flutterLocalNotificationsPlugin
            .show(
                notification.hashCode,
                notification.title,
                notification.body,
                NotificationDetails(
                  android: androidNotificationDetails,
                ))
            .onError((error, stackTrace) => print(error.toString()));
      }
    }
  }

  Future<void> loadFirebaseMessaging() async {
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        if (message.data['route'] != null) {
          if (message.data['route'] == 'POSTS') {
            Get.to(const PostList());
            return;
          }
          if (message.data['route'] == 'APPOINTMENTS') {
            Get.to(const AppointmentList());
            return;
          }
        }
        Get.to(const NotificationList());
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      loadDataToLocal(message).then((val) {
        if (message.data['route'] != null) {
          if (message.data['route'] == 'POSTS') {
            Get.to(const PostList());
            return;
          }
          if (message.data['route'] == 'APPOINTMENTS') {
            Get.to(const AppointmentList());
            return;
          }
        }
        Get.to(const NotificationList());
      });
    });
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, sound: true);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      loadDataToLocal(message).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.notification?.title ?? 'Notification Received.')));
      }).catchError((error) => print(error.toString()));
    });
  }
}
