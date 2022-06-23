import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/controllers/session.dart';
import 'package:saint_schoolparent_pro/firebase.dart';
import 'package:saint_schoolparent_pro/models/queue.dart';
import 'package:saint_schoolparent_pro/models/student.dart';

class QueueController extends GetxController {
  static QueueController instance = Get.find();

  List<StudentQueue> queuedStudents = [];

  StudentQueue? getQueue(String student) {
    var returns = queuedStudents.firstWhereOrNull((element) => element.icNumber == student);
    return returns;
  }

  Map<String, int> countdown = {};

  @override
  void onInit() {
    listenQueue();
    super.onInit();
  }

  pushToQueue(Student student) {
    var queue = StudentQueue(student: student, queuedTime: null);
    queueRef.doc(queue.icNumber).set(queue.toJson()).then((value) => queueRef.doc(queue.icNumber).update({"queuedTime": DateTime.now()}));
  }

  listenQueue() {
    queueRef.where('student.ic', whereIn: sessionController.parent!.children).snapshots().listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            var student = StudentQueue.fromJson(change.doc.data());
            queuedStudents.add(student);

            update();
            break;
          case DocumentChangeType.modified:
            var student = StudentQueue.fromJson(change.doc.data());
            if (student.queueStatus == QueueStatus.inQueue) {
              queuedStudents.removeWhere((element) => element.icNumber == student.icNumber);
              queuedStudents.add(student);
              Timer.periodic(const Duration(seconds: 1), (timer) {
                countdown[student.icNumber] = 10 - timer.tick;
                if (timer.tick == 10) {
                  change.doc.reference.delete();
                  countdown[student.icNumber] = 10;
                  timer.cancel();
                }
                update();
              });
            }
            break;
          case DocumentChangeType.removed:
            queuedStudents.removeWhere((element) => element.icNumber == change.doc.id);
            countdown.remove(change.doc.id);
            update();
            break;
        }
        update();
      }
    });
  }
}

QueueController queueController = QueueController.instance;
