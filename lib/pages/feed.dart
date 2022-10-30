import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:pinpoint/items/post_item.dart';
import '../items/end_of_scroll_item.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            displacement: 20,
            onRefresh: _refresh,
            child: FirestoreQueryBuilder<dynamic>(
              pageSize: 100,
              query: FirebaseFirestore.instance
                  .collection("pinpoint_post")
                  .orderBy('date', descending: true),
              builder: (context, snapshot, _) {
                if (snapshot.isFetching) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('error ${snapshot.error}');
                }

                return ListView.builder(
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
          ),
        ),
      ],
    );
  }

  Future<void> _refresh() {
    setState(() {});
    return Future.delayed(const Duration(seconds: 3));
  }
}
