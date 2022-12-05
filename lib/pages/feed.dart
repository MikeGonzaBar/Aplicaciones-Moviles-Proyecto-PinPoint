import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pinpoint/items/post_item.dart';
import 'package:pinpoint/providers/posts_provider.dart';
import 'package:provider/provider.dart';
import '../items/end_of_scroll_item.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  int filter = 0;
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
              await _getList(context, filter);
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
            },
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: OutlinedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              log('All');
                              filter = 0;
                              _getList(context, 0);
                            });
                          },
                          child: Text(
                            'All',
                            style: TextStyle(
                              color: filter == 0
                                  ? const Color(0xFFFF7A06)
                                  : Color(0xFF009fb7),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: OutlinedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0))),
                          ),
                          onPressed: () {
                            setState(() {
                              log('Close to you');
                              filter = 1;
                              _getList(context, 1);
                            });
                          },
                          child: Text(
                            'Close to you',
                            style: TextStyle(
                              color: filter == 1
                                  ? const Color(0xFFFF7A06)
                                  : Color(0xFF009fb7),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: OutlinedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0))),
                          ),
                          onPressed: () {
                            setState(() {
                              log('500m - 1km');
                              filter = 2;
                              _getList(context, 2);
                            });
                          },
                          child: Text(
                            '500m - 1km',
                            style: TextStyle(
                              color: filter == 2
                                  ? const Color(0xFFFF7A06)
                                  : Color(0xFF009fb7),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: OutlinedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0))),
                          ),
                          onPressed: () {
                            setState(() {
                              log('1 - 2km');
                              filter = 3;
                              _getList(context, 3);
                            });
                          },
                          child: Text(
                            '1 - 2km',
                            style: TextStyle(
                              color: filter == 3
                                  ? const Color(0xFFFF7A06)
                                  : Color(0xFF009fb7),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        context.watch<PostsProvider>().getPostsList.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (context.watch<PostsProvider>().getPostsList.length ==
                          0) {
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
                          postObject: context
                              .watch<PostsProvider>()
                              .getPostsList[index],
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
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _getList(BuildContext context, int filterOption) async {
    await context.read<PostsProvider>().getList(filterOption);
  }
}
