import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class PostsProvider with ChangeNotifier {
  final List<dynamic> _postsList = [];
  dynamic get getPostsList => _postsList;

  Future<String> addNewPost(dynamic postObj) async {
    print('INSIDE PROVIDER');
    String response = '';
    print(postObj);
    print('response');
    await FirebaseFirestore.instance.collection('pinpoint_post').add(
          ({
            'down_votes': [],
            'up_votes': [],
            'date': DateTime.now(),
            'date_limit':
                DateTime.now().add(Duration(days: postObj["daysActive"])),
            'image': '',
            'is_anonymous': postObj["isAnon"],
            'longitude': postObj["location"].longitude,
            'latitude': postObj["location"].latitude,
            'text': postObj["text"],
            'user_id': FirebaseAuth.instance.currentUser!.uid
          }),
        );

    notifyListeners();
    return response;
  }

  void getPosts(dynamic userObj) async {}
  void getMyPosts(dynamic userObj) async {}
}
