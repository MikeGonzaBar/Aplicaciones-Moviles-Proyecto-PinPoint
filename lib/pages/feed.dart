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
          child: RefreshIndicator(
            displacement: 0,
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            onRefresh: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Refreshing your feed...'),
                ),
              );
              await _getList(context);
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
            },
            child: ListView.builder(
              itemCount: context.watch<PostsProvider>().getPostsList.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (context.watch<PostsProvider>().getPostsList.length == 0) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(top: 30.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                          "No PinPoints found near your area.\nTry refreshing to check again! 😉",
                        ),
                      )
                    ],
                  );
                }
                if (index !=
                    context.watch<PostsProvider>().getPostsList.length) {
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
        ),
      ],
    );
  }

  Future<void> _getList(BuildContext context) async {
    await context.read<PostsProvider>().getList();
  }
}
