import 'package:firebase_messaging/firebase_messaging.dart';
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
    PostList(),
  ];

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        var notification = message.notification;
        var androidNotification = message.notification!.android;

        if (notification != null && androidNotification != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                  android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: androidNotification.smallIcon,
              )));
        }
      }
    });
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
            icon: Icon(Icons.add_alert),
            label: 'Announcements',
          ),
        ],
        currentIndex: _selectedIndex,
        // selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
