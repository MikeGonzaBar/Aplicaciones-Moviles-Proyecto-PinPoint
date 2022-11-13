
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:pinpoint/items/comment_item.dart';
import 'package:pinpoint/providers/comments_provider.dart';
import 'package:pinpoint/providers/posts_provider.dart';
import 'package:pinpoint/widgets/time_distance_text.dart';
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
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // POST AND COMMENTS COLUMN
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // POST CONTAINER
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffe8eaed),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // MAIN TEXT
                              Text(
                                widget.postData["text"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              // IMAGE
                              if (widget.postData["image"] != "")
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.75,
                                        image: NetworkImage(
                                            widget.postData["image"]),
                                      ),
                                    ),
                                  ),
                                ),
                              // AUTHOR
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  "${widget.postData["is_anonymous"] ? "Anonymous" : widget.postData["username"]}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              // POST INFO AND BUTTONS
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 5,
                                        child: TimeDistanceText(
                                            postObject: widget.postData)),
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          shareContent(
                                              context, widget.postData);
                                        },
                                        child: const Icon(
                                          Icons.share,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(
                                            Icons.comment_outlined,
                                            size: 20,
                                          ),
                                          Text(
                                            "${widget.postData["comments_number"]}",
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            onTap: _downVote,
                                            child: Icon(
                                              (Icons
                                                  .keyboard_arrow_down_rounded),
                                              size: 30,
                                              color: widget
                                                      .postData["down_votes"]
                                                      .contains(FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid)
                                                  ? const Color(0xFFFF7A06)
                                                  : Colors.black,
                                            ),
                                          ),
                                          Text(
                                            _getVotesNumber(),
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                          GestureDetector(
                                            onTap: _upVote,
                                            child: Icon(
                                              (Icons.keyboard_arrow_up_rounded),
                                              size: 30,
                                              color: widget.postData["up_votes"]
                                                      .contains(FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid)
                                                  ? const Color(0xFFFF7A06)
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        // COMMENT TEXT DIVIDER
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Comentarios:"),
                        ),
                        // COMMENT CONTAINER
                        FirestoreQueryBuilder<dynamic>(
                          pageSize: 100,
                          query: FirebaseFirestore.instance
                              .collection("pinpoint_comments")
                              .where('post_id',
                                  isEqualTo: widget.postData['post_id']),
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
                                  return CommentItem(
                                      commentData: snapshot.docs[index]);
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
                  ],
                ),
              ),
            ),
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
