import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/controllers/auth.dart';
import 'package:saint_schoolparent_pro/controllers/parent.dart';
import 'package:saint_schoolparent_pro/controllers/postlist%20_controller.dart';
import 'package:saint_schoolparent_pro/firebase.dart';
import 'package:saint_schoolparent_pro/models/parent.dart';
import 'package:saint_schoolparent_pro/models/result.dart';

import 'package:saint_schoolparent_pro/screens/bottomrouter.dart';
import 'package:saint_schoolparent_pro/screens/loginpage.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return StreamBuilder<Parent>(
              stream: ParentController.getProfileStream(),
              builder: (BuildContext context, AsyncSnapshot<Parent> snapshot) {
                if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
                  Get.put(() => PostListController());
                  Parent parent = snapshot.data!;
                  messaging.getToken().then((val) {
                    if (val != null) {
                      return ParentController(parent: parent).updateFcm(val);
                    } else {
                      return Result.error("Token not generated");
                    }
                  });
                  return BottomRouter(parent: parent);
                }
                if (snapshot.hasError) {
                  return Center(
                      child: AlertDialog(
                    title: const Text("Error occured"),
                    content: Text(snapshot.error.toString()),
                  ));
                }
                return const Center(child: CircularProgressIndicator());
              },
            );
          } else {
            return const LoginPage();
          }
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
