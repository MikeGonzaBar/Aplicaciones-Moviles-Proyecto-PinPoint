import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class PostsProvider with ChangeNotifier {
  final List<dynamic> _postsList = [];
  dynamic get getPostsList => _postsList;

  Future<String> addNewPost(dynamic postObj) async {
    // print('INSIDE PROVIDER');
    String response = '';
    // print(postObj);
    // print('response');
    var postId =
        await FirebaseFirestore.instance.collection('pinpoint_post').add(
              ({
                'comments_number': 0,
                'date': DateTime.now(),
                'date_limit':
                    DateTime.now().add(Duration(days: postObj["daysActive"])),
                'down_votes': [],
                'image': '',
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
    return response;
  }

  void getPosts(dynamic userObj) async {
    //GET CODE
  }
  void getMyPosts(dynamic userObj) async {}

  downVotePost(postObject) async {
    // print(postObject["post_id"]);
    // print(postObject["down_votes"]);
    List<dynamic> downVotes = postObject["down_votes"];
    // print(downVotes);
    downVotes.add(FirebaseAuth.instance.currentUser!.uid);
    // print(downVotes);
    FirebaseFirestore.instance
        .collection('pinpoint_post')
        .doc(postObject["post_id"])
        .update({'down_votes': downVotes});

    return;
  }

  upVotePost(postObject) async {
    // print(postObject["post_id"]);
    // print(postObject["up_votes"]);
    List<dynamic> upVotes = postObject["up_votes"];
    upVotes.add(FirebaseAuth.instance.currentUser!.uid);
    // print(upVotes);
    FirebaseFirestore.instance
        .collection('pinpoint_post')
        .doc(postObject["post_id"])
        .update({'up_votes': upVotes});

    return;
  }

  removeDownVotePost(postObject) {
    // print(postObject["post_id"]);
    // print(postObject["down_votes"]);
    List<dynamic> downVotes = postObject["down_votes"];
    // print(downVotes);
    downVotes.remove(FirebaseAuth.instance.currentUser!.uid);
    // print(downVotes);
    FirebaseFirestore.instance
        .collection('pinpoint_post')
        .doc(postObject["post_id"])
        .update({'down_votes': downVotes});

    return;
  }

  removeUpVotePost(postObject) {
    // print(postObject["post_id"]);
    // print(postObject["up_votes"]);
    List<dynamic> upVotes = postObject["up_votes"];
    // print(upVotes);
    upVotes.remove(FirebaseAuth.instance.currentUser!.uid);
    // print(upVotes);
    FirebaseFirestore.instance
        .collection('pinpoint_post')
        .doc(postObject["post_id"])
        .update({'up_votes': upVotes});

    return;
  }
}
