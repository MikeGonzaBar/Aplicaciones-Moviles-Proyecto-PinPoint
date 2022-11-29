import 'package:flutter/material.dart';
import 'package:pinpoint/items/post_item.dart';
import 'package:pinpoint/providers/posts_provider.dart';
import 'package:provider/provider.dart';
import '../items/end_of_scroll_item.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    // _getList(context);
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: context.watch<PostsProvider>().getPostsList.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index != context.watch<PostsProvider>().getPostsList.length) {
                return PostItem(
                  postObject:
                      context.watch<PostsProvider>().getPostsList[index],
                  isInComment: false,
                  isMyPost: false,
                );
              } else {
                // If index is last, add ending dot
                return const EndOfScrollItem();
              }
            },
          ),
        ),
      ],
    );
  }
}
