import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class PostsProvider with ChangeNotifier {
  final List<dynamic> _postsList = [];
  dynamic get getPostsList => _postsList;

  Future<bool> addNewPost(dynamic postObj) async {
    try {
      var postId =
          await FirebaseFirestore.instance.collection('pinpoint_post').add(
                ({
                  'comments_number': 0,
                  'date': DateTime.now(),
                  'date_limit':
                      DateTime.now().add(Duration(days: postObj["daysActive"])),
                  'down_votes': [],
                  'image': postObj["image"],
                  'is_anonymous': postObj["isAnon"],
                  'latitude': postObj["location"].latitude,
                  'longitude': postObj["location"].longitude,
                  'text': postObj["text"],
                  'up_votes': [],
                  'user_id': FirebaseAuth.instance.currentUser!.uid,
                  'username': FirebaseAuth.instance.currentUser!.displayName
                }),
              );
      FirebaseFirestore.instance
          .collection('pinpoint_post')
          .doc(postId.id)
          .update({'post_id': postId.id});
      notifyListeners();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<void> downVotePost(postObject) async {
    try {
      List<dynamic> downVotes = postObject["down_votes"];
      downVotes.add(FirebaseAuth.instance.currentUser!.uid);

      FirebaseFirestore.instance
          .collection('pinpoint_post')
          .doc(postObject["post_id"])
          .update({'down_votes': downVotes});

      return;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> upVotePost(postObject) async {
    try {
      List<dynamic> upVotes = postObject["up_votes"];
      upVotes.add(FirebaseAuth.instance.currentUser!.uid);

      FirebaseFirestore.instance
          .collection('pinpoint_post')
          .doc(postObject["post_id"])
          .update({'up_votes': upVotes});

      return;
    } catch (e) {
      log(e.toString());
    }
  }

  removeDownVotePost(postObject) {
    try {
      List<dynamic> downVotes = postObject["down_votes"];
      downVotes.remove(FirebaseAuth.instance.currentUser!.uid);

      FirebaseFirestore.instance
          .collection('pinpoint_post')
          .doc(postObject["post_id"])
          .update({'down_votes': downVotes});

      return;
    } catch (e) {
      log(e.toString());
    }
  }

  removeUpVotePost(postObject) {
    try {
      List<dynamic> upVotes = postObject["up_votes"];
      upVotes.remove(FirebaseAuth.instance.currentUser!.uid);

      FirebaseFirestore.instance
          .collection('pinpoint_post')
          .doc(postObject["post_id"])
          .update({'up_votes': upVotes});

      return;
    } catch (e) {
      log(e.toString());
    }
  }
}
