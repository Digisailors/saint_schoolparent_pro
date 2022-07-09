import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:saint_schoolparent_pro/controllers/session.dart';
import 'package:saint_schoolparent_pro/firebase.dart';
import 'package:saint_schoolparent_pro/models/post.dart';

class PostListController extends GetxController {
  static PostListController instance = Get.find();

  List<Post> posts = [];
  List<Post> personalPosts = [];

  @override
  void onInit() {
    listenPosts();
    super.onInit();
  }

  listenPosts() {
    postsRef.orderBy('date', descending: true).snapshots().listen((event) {
      posts = event.docs.map((e) => Post.fromJson(e.data(), e.id)).toList();
      update();
    });

    myPosts.orderBy('date', descending: true).snapshots().listen((event) {
      personalPosts = event.docs.map((e) => Post.fromJson(e.data(), e.id)).toList();
      update();
    });

    // postsRef.snapshots().forEach((event) {
    //   for (var change in event.docChanges) {
    //     var document = change.doc;
    //     var post = change.doc.exists ? Post.fromJson(document.data(), document.id) : null;
    //     switch (change.type) {
    //       case DocumentChangeType.added:
    //         if (post != null) {
    //           posts.add(post);
    //         }
    //         break;
    //       case DocumentChangeType.modified:
    //         if (post != null) {
    //           posts.removeWhere((element) => element.docId == change.doc.id);
    //           posts.add(post);
    //         }
    //         break;
    //       case DocumentChangeType.removed:
    //         posts.removeWhere((element) => element.docId == change.doc.id);
    //         break;
    //     }
    //   }
    //   posts.sort(
    //     (a, b) => b.date.compareTo(a.date),
    //   );
    //   update();
    // });

    // myPosts.snapshots().forEach((event) {
    //   for (var change in event.docChanges) {
    //     var document = change.doc;
    //     var post = change.doc.exists ? Post.fromJson(document.data(), document.id) : null;
    //     switch (change.type) {
    //       case DocumentChangeType.added:
    //         if (post != null) {
    //           personalPosts.insert(change.newIndex, post);
    //         }
    //         break;
    //       case DocumentChangeType.modified:
    //         if (post != null) {
    //           int index = personalPosts.indexWhere((element) => element.docId == change.doc.id);
    //           personalPosts[index] = post;
    //         }
    //         break;
    //       case DocumentChangeType.removed:
    //         personalPosts.removeWhere((element) => element.docId == change.doc.id);
    //         break;
    //     }
    //     personalPosts.sort(
    //       (a, b) => b.date.compareTo(a.date),
    //     );
    //   }
    //   update();
    // });
  }

  List<String> get searchElement {
    var array = sessionController.session.parent!.children;
    array.add(sessionController.session.parent!.icNumber);
    return array;
  }

  final Query<Map<String, dynamic>> postsRef = firestore.collection('posts').where('audience', isEqualTo: Audience.all.index);
  Query<Map<String, dynamic>> get myPosts =>
      firestore.collection('posts').where('audience', isEqualTo: Audience.single.index).where('sentTo.icNumber', whereIn: searchElement);
  // .where('sentTo.icNumber', whereIn: sessionController.session.parent!.children);
}

PostListController announcementListController = PostListController.instance;
