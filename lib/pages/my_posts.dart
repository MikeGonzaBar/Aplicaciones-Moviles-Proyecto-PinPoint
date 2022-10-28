import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinpoint/items/post_item.dart';
import '../items/end_of_scroll_item.dart';
import '../temp_data.dart' as temp_data;
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
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: temp_data.myPostsList.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index != temp_data.myPostsList.length) {
                return PostItem(
                  postObject: temp_data.myPostsList[index],
                );
              } else {
                // If index is last, add ending dot
                return const EndOfScrollItem();
              }
            },
          )
        ],
      ),
    );
  }
}
