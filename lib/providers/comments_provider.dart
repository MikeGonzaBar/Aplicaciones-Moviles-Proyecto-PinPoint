import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class CommentsProvider with ChangeNotifier {
  List<dynamic> _commentsList = [];
  List<dynamic> get getCommentsList => _commentsList;

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
          .collection('pinpoint_comments')
          .doc(commentId.id)
          .update({'comment_id': commentId.id});

      DocumentSnapshot<Map<String, dynamic>> post = await FirebaseFirestore
          .instance
          .collection('pinpoint_post')
          .doc(postObj["post_id"])
          .get();

      log('COMMENTS NUMBER IN CLOUD ${post.data()!['comments_number']}');
      int cloudCommentsNum = post.data()!['comments_number'];

      FirebaseFirestore.instance
          .collection('pinpoint_post')
          .doc(postObj["post_id"])
          .update({'comments_number': cloudCommentsNum + 1});
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

  void updateComments(snapshot) {
    _commentsList = snapshot.docs;
  }

  Future<void> resetComments({required postData}) async {
    _commentsList = [];

    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("pinpoint_comments")
        .where('post_id', isEqualTo: postData['post_id'])
        .get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot.docs;

    for (var doc in docs) {
      dynamic comment = doc.data();
      _commentsList.add(comment);
    }

    notifyListeners();
  }
}
