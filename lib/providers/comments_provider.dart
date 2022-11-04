import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class CommentsProvider with ChangeNotifier {
  final List<dynamic> _commentsList = [];
  dynamic get getCommentsList => _commentsList;

  Future<bool> sendComment(postObj, comment) async {
    try {
      var commentId =
          await FirebaseFirestore.instance.collection('pinpoint_comments').add(
                ({
                  'down_votes': [],
                  'post_id': postObj["post_id"],
                  'text': comment,
                  'up_votes': [],
                  'username': FirebaseAuth.instance.currentUser!.displayName
                }),
              );
      FirebaseFirestore.instance
          .collection('pinpoint_post')
          .doc(postObj["post_id"])
          .update({'comments_number': postObj["comments_number"] + 1});
      FirebaseFirestore.instance
          .collection('pinpoint_comments')
          .doc(commentId.id)
          .update({'comment_id': commentId.id});
      notifyListeners();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<void> downVoteComment(commentObject) async {
    try {
      List<dynamic> downVotes = commentObject["down_votes"];
      downVotes.add(FirebaseAuth.instance.currentUser!.uid);

      FirebaseFirestore.instance
          .collection('pinpoint_comments')
          .doc(commentObject["comment_id"])
          .update({'down_votes': downVotes});

      return;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> upVoteComment(commentObject) async {
    try {
      List<dynamic> upVotes = commentObject["up_votes"];
      upVotes.add(FirebaseAuth.instance.currentUser!.uid);

      FirebaseFirestore.instance
          .collection('pinpoint_comments')
          .doc(commentObject["comment_id"])
          .update({'up_votes': upVotes});

      return;
    } catch (e) {
      log(e.toString());
    }
  }

  removeDownVoteComment(commentObject) {
    try {
      List<dynamic> downVotes = commentObject["down_votes"];
      downVotes.remove(FirebaseAuth.instance.currentUser!.uid);

      FirebaseFirestore.instance
          .collection('pinpoint_comments')
          .doc(commentObject["comment_id"])
          .update({'down_votes': downVotes});

      return;
    } catch (e) {
      log(e.toString());
    }
  }

  removeUpVoteComment(commentObject) {
    try {
      List<dynamic> upVotes = commentObject["up_votes"];
      upVotes.remove(FirebaseAuth.instance.currentUser!.uid);

      FirebaseFirestore.instance
          .collection('pinpoint_comments')
          .doc(commentObject["comment_id"])
          .update({'up_votes': upVotes});

      return;
    } catch (e) {
      log(e.toString());
    }
  }
}
