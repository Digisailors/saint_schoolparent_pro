import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/controllers/session.dart';
import 'package:saint_schoolparent_pro/firebase.dart';
import 'package:saint_schoolparent_pro/models/queue.dart';
import 'package:saint_schoolparent_pro/models/student.dart';

class QueueListController extends GetxController {
  static QueueListController instance = Get.find();

  List<StudentQueue> queuedStudents = [];

  StudentQueue? getQueue(String student) {
    var returns = queuedStudents.firstWhereOrNull((element) => element.icNumber == student);
    return returns;
  }

  static const int seconds = 60;

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
    queueRef.where('student.icNumber', whereIn: sessionController.parent!.children).snapshots().listen((event) {
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
              int index = queuedStudents.indexWhere((element) => element.icNumber == student.icNumber);

              queuedStudents[index].timer = queuedStudents[index].timer ??
                  Timer.periodic(const Duration(seconds: 1), (timer) {
                    countdown[student.icNumber] = seconds - timer.tick;
                    print(countdown[student.icNumber]);
                    if (timer.tick == seconds) {
                      countdown[student.icNumber] = seconds;
                      timer.cancel();
                    }
                    update();
                  });
            } else {
              student.queueStatus = QueueStatus.inQueue;
            }
            break;
          case DocumentChangeType.removed:
            var student = StudentQueue.fromJson(change.doc.data());
            int index = queuedStudents.indexWhere((element) => element.icNumber == student.icNumber);
            queuedStudents[index].timer?.cancel();
            queuedStudents.removeAt(index);
            countdown.remove(change.doc.id);
            update();
            break;
        }
        update();
      }
    });
  }
}

QueueListController queueListController = QueueListController.instance;
