import 'package:flutter/material.dart';
import 'package:pinpoint/items/post_item.dart';
import '../items/end_of_scroll_item.dart';
import '../temp_data.dart' as temp_data;

class Feed extends StatelessWidget {
  const Feed({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            displacement: 20,
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: temp_data.feedList.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index != temp_data.feedList.length) {
                  return PostItem(
                    postObject: temp_data.feedList[index],
                  );
                } else {
                  // If index is last, add ending dot
                  return EndOfScrollItem();
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _refresh() {
    return Future.delayed(Duration(seconds: 3));
  }
}
