import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class PostsProvider with ChangeNotifier {
  List<dynamic> _filteredPostsList = [];
  List<dynamic> _allPostsList = [];
  dynamic get getPostsList => _filteredPostsList;

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
      await FirebaseFirestore.instance
          .collection('pinpoint_post')
          .doc(postId.id)
          .update({'post_id': postId.id});
      _filteredPostsList.insert(0, {
        'comments_number': 0,
        'date': Timestamp.fromDate(DateTime.now()),
        'date_limit': Timestamp.fromDate(
            DateTime.now().add(Duration(days: postObj["daysActive"]))),
        'down_votes': [],
        'image': postObj["image"],
        'is_anonymous': postObj["isAnon"],
        'latitude': postObj["location"].latitude,
        'longitude': postObj["location"].longitude,
        'post_id': postId.id,
        'text': postObj["text"],
        'up_votes': [],
        'user_id': FirebaseAuth.instance.currentUser!.uid,
        'username': FirebaseAuth.instance.currentUser!.displayName
      });
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

      int postIndex = _filteredPostsList.indexOf(postObject);
      _filteredPostsList[postIndex]['down_votes'] = downVotes;

      notifyListeners();

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

      int postIndex = _filteredPostsList.indexOf(postObject);
      _filteredPostsList[postIndex]["up_votes"] = upVotes;

      notifyListeners();

      return;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> removeDownVotePost(postObject) async {
    try {
      List<dynamic> downVotes = postObject["down_votes"];
      downVotes.remove(FirebaseAuth.instance.currentUser!.uid);

      FirebaseFirestore.instance
          .collection('pinpoint_post')
          .doc(postObject["post_id"])
          .update({'down_votes': downVotes});

      int postIndex = _filteredPostsList.indexOf(postObject);
      _filteredPostsList[postIndex]['down_votes'] = downVotes;

      notifyListeners();

      return;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> removeUpVotePost(postObject) async {
    try {
      List<dynamic> upVotes = postObject["up_votes"];
      upVotes.remove(FirebaseAuth.instance.currentUser!.uid);

      FirebaseFirestore.instance
          .collection('pinpoint_post')
          .doc(postObject["post_id"])
          .update({'up_votes': upVotes});

      int postIndex = _filteredPostsList.indexOf(postObject);
      _filteredPostsList[postIndex]["up_votes"] = upVotes;

      notifyListeners();

      return;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getList(int filterOption) async {
    QuerySnapshot<Map<String, dynamic>> postsSnapshot = await FirebaseFirestore
        .instance
        .collection('pinpoint_post')
        .orderBy('date', descending: true)
        .get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = postsSnapshot.docs;

    filterList(docs, filterOption);

    notifyListeners();
  }

  Future<void> filterList(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
      int filterOption) async {
    Position position = await _getPosition();

    _allPostsList = [];
    _filteredPostsList = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docs) {
      dynamic post = doc.data();
      DateTime limitDate = (post['date_limit'] as Timestamp).toDate();
      DateTime today = DateTime.now();
      if (today.isBefore(limitDate) &&
          !_filteredPostsList.contains(post) &&
          await _getProximity(post, position, filterOption)) {
        _filteredPostsList.add(post);
      }
      _allPostsList.add(post);
    }

    notifyListeners();
  }

  Future<Position> _getPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<bool> _getProximity(
      dynamic post, Position position, int filterOption) async {
    var distanceInMeters = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      post["latitude"],
      post["longitude"],
    );
    log(filterOption.toString());

    // bool response = distanceInMeters <= 2000 ? true : false;
    bool response = filterOption == 0
        ? distanceInMeters <= 2000
            ? true
            : false
        : filterOption == 1
            ? distanceInMeters < 500
                ? true
                : false
            : filterOption == 2
                ? distanceInMeters > 500 && distanceInMeters <= 1000
                    ? true
                    : false
                : distanceInMeters > 1000 && distanceInMeters <= 2000
                    ? true
                    : false;

    return response;
  }

  dynamic deleteMyPost(postObject) async {
    int index = getlocalIndex(postObject);

    if (index != -1) {
      _filteredPostsList.removeAt(index);
    }
    await FirebaseFirestore.instance
        .collection('pinpoint_post')
        .doc(postObject['post_id'])
        .delete()
        .then((value) => log("Post Deleted"))
        .catchError((error) => log("Failed to delete post: $error"));

    var commentsQuery = await FirebaseFirestore.instance
        .collection('pinpoint_comments')
        .where('post_id', isEqualTo: postObject['post_id'])
        .get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> comments =
        commentsQuery.docs;

    for (var doc in comments) {
      dynamic comment = doc.data();

      await FirebaseFirestore.instance
          .collection('pinpoint_comments')
          .doc(comment['comment_id'])
          .delete()
          .then((value) => log("Coment Deleted"))
          .catchError((error) => log("Failed to delete comment: $error"));
    }
    notifyListeners();
  }

  cleanLists() {
    _filteredPostsList = [];
    _allPostsList = [];
  }

  Future<void> updateCommentsNumber(postData, int length) async {
    //UpdateLocalCommentNumber()
    int index = getlocalIndex(postData);

    try {
      postData['comments_number'] = length;
    } catch (e) {
      Map<String, dynamic> newPostData = postData.data();
      newPostData['comments_number'] = length;
      postData = newPostData;
    }

    _filteredPostsList[index] = postData;

    await FirebaseFirestore.instance
        .collection('pinpoint_post')
        .doc(postData["post_id"])
        .update({'comments_number': length})
        .then((value) => log("Comment number updated"))
        .catchError((error) => log("Failed to update comment number: $error"));

    // postData

    // _filteredPostsList[index]
  }

  int getlocalIndex(postObject) {
    int index = -1;
    for (var i = 0; i < _filteredPostsList.length; i++) {
      if (_filteredPostsList[i]['post_id'] == postObject['post_id']) {
        index = i;
        break;
      }
    }
    return index;
  }
}
