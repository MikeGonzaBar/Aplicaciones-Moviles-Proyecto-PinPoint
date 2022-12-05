import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:pinpoint/items/comment_item.dart';
import 'package:pinpoint/items/post_item.dart';
import 'package:pinpoint/providers/comments_provider.dart';
import 'package:pinpoint/providers/posts_provider.dart';
import 'package:provider/provider.dart';
import '../items/end_of_scroll_item.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentSection extends StatefulWidget {
  final dynamic postData;
  const CommentSection({super.key, required this.postData});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

final commentController = TextEditingController();

class _CommentSectionState extends State<CommentSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comentarios'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SingleChildScrollView(
                child: FirestoreQueryBuilder<dynamic>(
                    pageSize: 100,
                    query: FirebaseFirestore.instance
                        .collection("pinpoint_post")
                        .where('post_id',
                            isEqualTo: widget.postData['post_id']),
                    builder: (context, snapshotDoc, _) {
                      if (snapshotDoc.isFetching) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshotDoc.hasError) {
                        return Text('error ${snapshotDoc.error}');
                      }
                      log('DOCUMENT SNAPSHOT' + snapshotDoc.docs.toString());
                      QueryDocumentSnapshot<dynamic> postSnapshot =
                          snapshotDoc.docs.first;
                      log('QUERY DOCUMENT SNAPSHOT' + postSnapshot.toString());
                      dynamic post = postSnapshot.data();
                      log('QUERY DOCUMENT SNAPSHOT' + post.toString());

                      // log('DOCUMENT SNAPSHOT'+snapshotDoc.docs.toString());
                      return FirestoreQueryBuilder<dynamic>(
                          pageSize: 100,
                          query: FirebaseFirestore.instance
                              .collection("pinpoint_comments")
                              .where('post_id',
                                  isEqualTo: widget.postData['post_id'])
                              .orderBy('date', descending: true),
                          builder: (context, snapshot, _) {
                            if (snapshot.isFetching) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Text('error ${snapshot.error}');
                            }

                            context
                                .watch<CommentsProvider>()
                                .updateComments(snapshot);

                            List<dynamic> reversedSnapshot = context
                                .watch<CommentsProvider>()
                                .getCommentsList;
                            context.read<PostsProvider>().updateCommentsNumber(
                                widget.postData, reversedSnapshot.length);

                            return Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    PostItem(
                                        postObject: post,
                                        isInComment: true,
                                        isMyPost: false),
                                    // COMMENT TEXT DIVIDER
                                    const Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          20.0, 8.0, 20.0, 8.0),
                                      child: Text("Comentarios:"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12.0, right: 12.0),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: reversedSnapshot.length + 1,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (snapshot.hasMore &&
                                              index + 1 ==
                                                  snapshot.docs.length) {
                                            // Tell FirestoreQueryBuilder to try to obtain more items.
                                            // It is safe to call this function from within the build method.
                                            snapshot.fetchMore();
                                          }
                                          if (index !=
                                              reversedSnapshot.length) {
                                            return CommentItem(
                                                commentData:
                                                    reversedSnapshot[index]);
                                          } else {
                                            // If index is last, add ending dot
                                            return const EndOfScrollItem();
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          });
                    })),
            // TEXT INPUT CONTAINER
            Positioned(
              bottom: 10,
              left: 20,
              right: 20,
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: TextField(
                    controller: commentController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: "Comment something...",
                      filled: true,
                      fillColor: const Color(0xfffafafa),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          sendComment(commentController.text);
                        },
                      ),
                      // focusedBorder: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getVotesNumber() {
    var votes = widget.postData["up_votes"].length -
        widget.postData["down_votes"].length;
    return votes.toString();
  }

  Future<void> _downVote() async {
    if (widget.postData["down_votes"]
        .contains(FirebaseAuth.instance.currentUser!.uid)) {
      await context.read<PostsProvider>().removeDownVotePost(widget.postData);
    } else {
      await context.read<PostsProvider>().removeUpVotePost(widget.postData);
      if (!mounted) return;
      await context.read<PostsProvider>().downVotePost(widget.postData);
    }
    return;
  }

  Future<void> _upVote() async {
    if (widget.postData["up_votes"]
        .contains(FirebaseAuth.instance.currentUser!.uid)) {
      await context.read<PostsProvider>().removeUpVotePost(widget.postData);
    } else {
      await context.read<PostsProvider>().removeDownVotePost(widget.postData);
      if (!mounted) return;
      await context.read<PostsProvider>().upVotePost(widget.postData);
    }
    return;
  }

  Future<void> sendComment(text) async {
    if (await context
            .read<CommentsProvider>()
            .sendComment(widget.postData, text) ==
        true) {
      commentController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'There was an issue sending your comment. Please try again.'),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  Future<void> shareContent(BuildContext context, postObject) async {
    await FlutterShare.share(
        title: 'Check this new PinPoint!',
        text:
            'From PinPoint: ${postObject["username"]} said this ${timeago.format(postObject["date"].toDate())}: ${postObject["text"]}',
        chooserTitle: 'Share your PinPoint with anyone!');

    return;
  }
}
