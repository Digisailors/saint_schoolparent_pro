import 'dart:async';
import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/controllers/session.dart';
import 'package:saint_schoolparent_pro/firebase.dart';
import 'package:saint_schoolparent_pro/models/parent.dart';
import 'package:saint_schoolparent_pro/models/result.dart';
import 'package:saint_schoolparent_pro/models/student.dart';

import 'auth.dart';

class ParentController extends GetxController {
  ParentController({required this.parent});
  final Parent parent;

  static ParentController instance = Get.find();

  @override
  void onInit() {
    listenParent();
    sessionController.session.parent = parent;
    super.onInit();
  }

  List<Student> children = [];

  listenParent() {
    parents.doc(parent.icNumber).snapshots().listen((event) {
      if (event.exists) {
        var tempParent = Parent.fromJson(event.data()!);
        parent.copyWith(tempParent);
        update();
      }
    });
  }

  loadChildren() {
    students.where('icNumber', arrayContainsAny: parent.children).get().then((event) {
      children = event.docs.map((e) => Student.fromJson(e.data())).toList();
      update();
    });
  }

  Future<bool> verifyChild(String child) {
    return students.where('parent', arrayContains: parent.icNumber).get().then((value) {
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

  static Stream<Parent> getProfileStream() {
    return parents.where("uid", isEqualTo: auth.uid).snapshots().map((event) => event.docs.map((e) => Parent.fromJson(e.data())).first);
  }

  static Future<void> registerParent(Parent parent) {
    return parents.doc(parent.icNumber).set(parent.toJson());
  }

  static Future<Parent> getParent(String icNumber) {
    return parents.doc(icNumber).get().then((value) => Parent.fromJson(value.data()!));
  }

  static addParent(Parent parentData) {
    parents.doc(parentData.icNumber).set(parentData.toJson()).then((value) => Result.success("Parent added successflly"));
  }

  static Stream<List<Student>> streamChildrenByParent({required String parent}) {
    return students.where("parent", arrayContains: parent).snapshots().map((event) => event.docs.map((e) => Student.fromJson(e.data())).toList());
  }

  static Future<List<Student>> loadChildrenByparent({required String parent}) {
    return students.where("parent", arrayContains: parent).get().then((value) => value.docs.map((e) => Student.fromJson(e.data())).toList());
  }
}

ParentController parentController = ParentController.instance;
