import 'package:flutter/material.dart';
import 'package:pinpoint/items/post_item.dart';
import '../temp_data.dart' as temp_data;

class Feed extends StatelessWidget {
  const Feed({super.key});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: temp_data.FeedList.length,
        itemBuilder: (BuildContext context, int index) {
          return PostItem(
            postObject: temp_data.FeedList[index],
          );
        },
      ),
    );
  }
}
