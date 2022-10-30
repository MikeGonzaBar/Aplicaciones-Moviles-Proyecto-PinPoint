import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:pinpoint/items/post_item.dart';
import '../items/end_of_scroll_item.dart';
import 'package:timeago/timeago.dart' as timeago;

class MyPosts extends StatelessWidget {
  const MyPosts({super.key});
  @override
  Widget build(BuildContext context) {
    // padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "${FirebaseAuth.instance.currentUser!.displayName}",
                  style: const TextStyle(fontSize: 35),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    "User since ${timeago.format(FirebaseAuth.instance.currentUser!.metadata.creationTime ?? DateTime.now())}",
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    "You have collected 95 votes!",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    "Your most recent PinPoints:",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
          FirestoreQueryBuilder<dynamic>(
            pageSize: 100,
            query: FirebaseFirestore.instance
                .collection("pinpoint_post")
                .where("user_id",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .orderBy('date', descending: true),
            builder: (context, snapshot, _) {
              if (snapshot.isFetching) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('error ${snapshot.error}');
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.docs.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index != snapshot.docs.length) {
                    return PostItem(
                      postObject: snapshot.docs[index],
                      isInComment: false,
                    );
                  } else {
                    // If index is last, add ending dot
                    return const EndOfScrollItem();
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
