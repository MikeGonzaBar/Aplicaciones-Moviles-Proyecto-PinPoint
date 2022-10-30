import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class CommentsProvider with ChangeNotifier {
  final List<dynamic> _commentsList = [];
  dynamic get getCommentsList => _commentsList;

  void sendComment(postObj, comment) async {
    // print(postObj["post_id"]);
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
    return;
  }

  downVoteComment(commentObject) async {
    // print(commentObject["comment_id"]);
    // print(commentObject["down_votes"]);
    List<dynamic> downVotes = commentObject["down_votes"];
    // print(downVotes);
    downVotes.add(FirebaseAuth.instance.currentUser!.uid);
    // print(downVotes);
    FirebaseFirestore.instance
        .collection('pinpoint_comments')
        .doc(commentObject["comment_id"])
        .update({'down_votes': downVotes});

    return;
  }

  upVoteComment(commentObject) async {
    // print(commentObject["comment_id"]);
    // print(commentObject["up_votes"]);
    List<dynamic> upVotes = commentObject["up_votes"];
    upVotes.add(FirebaseAuth.instance.currentUser!.uid);
    // print(upVotes);
    FirebaseFirestore.instance
        .collection('pinpoint_comments')
        .doc(commentObject["comment_id"])
        .update({'up_votes': upVotes});

    return;
  }

  removeDownVoteComment(commentObject) {
    // print(commentObject["comment_id"]);
    // print(commentObject["down_votes"]);
    List<dynamic> downVotes = commentObject["down_votes"];
    // print(downVotes);
    downVotes.remove(FirebaseAuth.instance.currentUser!.uid);
    // print(downVotes);
    FirebaseFirestore.instance
        .collection('pinpoint_comments')
        .doc(commentObject["comment_id"])
        .update({'down_votes': downVotes});

    return;
  }

  removeUpVoteComment(commentObject) {
    // print(commentObject["comment_id"]);
    // print(commentObject["up_votes"]);
    List<dynamic> upVotes = commentObject["up_votes"];
    // print(upVotes);
    upVotes.remove(FirebaseAuth.instance.currentUser!.uid);
    // print(upVotes);
    FirebaseFirestore.instance
        .collection('pinpoint_comments')
        .doc(commentObject["comment_id"])
        .update({'up_votes': upVotes});

    return;
  }
}
