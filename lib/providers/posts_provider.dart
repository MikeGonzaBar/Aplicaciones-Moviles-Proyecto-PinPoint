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
      FirebaseFirestore.instance
          .collection('pinpoint_post')
          .doc(postId.id)
          .update({'post_id': postId.id});
      _filteredPostsList.add({
        'comments_number': 0,
        'date': Timestamp.fromDate(DateTime.now()),
        'date_limit': Timestamp.fromDate(
            DateTime.now().add(Duration(days: postObj["daysActive"]))),
        'down_votes': [],
        'image': postObj["image"],
        'is_anonymous': postObj["isAnon"],
        'latitude': postObj["location"].latitude,
        'longitude': postObj["location"].longitude,
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

  Future<void> getList() async {
    num newPostNumber = 0;
    QuerySnapshot<Map<String, dynamic>> postsSnapshot = await FirebaseFirestore
        .instance
        .collection('pinpoint_post')
        .orderBy('date', descending: true)
        .get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = postsSnapshot.docs;

    for (var doc in docs) {
      dynamic post = doc.data();

      if (!_allPostsList.toString().contains(post.toString())) {
        newPostNumber++;
      }
    }

    if (newPostNumber > 0) {
      filterList(docs);
    }
    notifyListeners();
  }

  Future<void> filterList(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) async {
    Position position = await _getPosition();

    // log(docs.toString());
    _allPostsList = [];
    _filteredPostsList = [];
    for (var doc in docs) {
      dynamic post = doc.data();
      DateTime limitDate = (post['date_limit'] as Timestamp).toDate();
      DateTime today = DateTime.now();
      if (today.isBefore(limitDate) &&
          !_filteredPostsList.contains(post) &&
          await _getProximity(post, position)) {
        // log('Limit: ${limitDate.toString()} - Today: ${DateTime.now()} - Text: ${post['text']}');
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

  Future<bool> _getProximity(dynamic post, Position position) async {
    var distanceInMeters = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      post["latitude"],
      post["longitude"],
    );

    bool response = distanceInMeters <= 2000 ? true : false;

    return response;
  }
}
