import 'dart:async';
import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/controllers/session.dart';
import 'package:saint_schoolparent_pro/firebase.dart';
import 'package:saint_schoolparent_pro/models/appointment.dart';
import 'package:saint_schoolparent_pro/models/parent.dart';
import 'package:saint_schoolparent_pro/models/result.dart';
import 'package:saint_schoolparent_pro/models/student.dart';

import 'auth.dart';

class ParentController extends GetxController {
  static List<Student> children = [];

  static Parent get parent => sessionController.session.parent!;

  static listenParent() {
    parents.doc(sessionController.session.parent!.icNumber).snapshots().listen((event) {
      if (event.exists) {
        var tempParent = Parent.fromJson(event.data()!);
        sessionController.session.parent?.copyWith(tempParent);
      }
    });
  }

  static loadChildren() {
    students.where('icNumber', arrayContainsAny: parent.children).get().then((event) {
      children = event.docs.map((e) => Student.fromJson(e.data())).toList();
    });
  }

  static Future<bool> verifyChild(String child) {
    return students.where('parents', arrayContains: parent.icNumber).get().then((value) {
      if (value.docs.isNotEmpty) {
        var childrenIcs = value.docs.map((e) => Student.fromJson(e.data()).icNumber).toList();
        if (childrenIcs.contains(child)) {
          parent.children.add(child);
          parents.doc(parent.icNumber).update(parent.toJson());
          return true;
        }
        return false;
      }
      return value.docs.isNotEmpty;
    });
  }

  static Stream<List<Appointment>> streamAppointments() {
    return firestore.collection('appointments').where("parent.icNumber", isEqualTo: parent.icNumber).snapshots().map(
        (event) => event.docs.map((e) => Appointment.fromJson(e.data(), e.id)).where((element) => element.date.isAfter(DateTime.now())).toList());
  }

  static Stream<List<Appointment>> streamFinishedAppointments() {
    return firestore.collection('appointments').where("parent.icNumber", isEqualTo: parent.icNumber).snapshots().map(
        (event) => event.docs.map((e) => Appointment.fromJson(e.data(), e.id)).where((element) => element.date.isBefore(DateTime.now())).toList());
  }

  static Stream<Parent?> getProfileStream() {
    return parents.where("uid", isEqualTo: auth.uid).snapshots().map((event) {
      if (event.docs.isEmpty) {
        return null;
      } else {
        return Parent.fromJson(event.docs.first.data());
      }
    });
  }

  static Future<void> registerParent(Parent parent) {
    return parents.doc(parent.icNumber).set(parent.toJson());
  }

  static Future<Parent> getParent(String icNumber) {
    return parents.doc(icNumber).get().then((value) => Parent.fromJson(value.data()!));
  }

  static Future<Result> updateFcm(String fcm) {
    // printInfo(info: parent.icNumber);
    return firestore
        .collection('parents')
        .doc(parent.icNumber)
        .update({"fcm": fcm})
        .then((value) => Result.success("FCM Token updated successfully"))
        .catchError((error) => Result.error(error));
  }

  static addParent(Parent parentData) {
    parents.doc(parentData.icNumber).set(parentData.toJson()).then((value) => Result.success("Parent added successflly"));
  }

  static Stream<List<Student>> streamChildrenByParent({required String parent}) {
    return students.where("parents", arrayContains: parent).snapshots().map((event) => event.docs.map((e) => Student.fromJson(e.data())).toList());
  }

  static Future<List<Student>> loadChildrenByparent({required String parent}) {
    return students.where("parents", arrayContains: parent).get().then((value) => value.docs.map((e) => Student.fromJson(e.data())).toList());
  }
}
