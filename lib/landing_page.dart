import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/controllers/auth.dart';
import 'package:saint_schoolparent_pro/controllers/parent.dart';

import 'package:saint_schoolparent_pro/controllers/session.dart';
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
            // auth.signOut();
            return StreamBuilder<Parent?>(
              stream: ParentController.getProfileStream(),
              builder: (BuildContext context, AsyncSnapshot<Parent?> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    Parent parent = snapshot.data!;
                    sessionController.session.parent = parent;
                    messaging.getToken().then((val) {
                      if (val != null) {
                        return ParentController.updateFcm(val);
                      } else {
                        return Result.error("Token not generated");
                      }
                    });
                    return BottomRouter(parent: parent);
                  } else {
                    return Center(
                        child: AlertDialog(
                      title: const Text("No Parent Profile Availble"),
                      content: const Text("There is no parent profile available for this device. Please contact admin"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              auth.signOut();
                              Get.offAll(() => const LandingPage());
                            },
                            child: const Text("OKAY"))
                      ],
                    ));
                  }
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
