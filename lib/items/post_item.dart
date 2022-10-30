import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinpoint/pages/comment_section.dart';
import 'package:pinpoint/providers/posts_provider.dart';
import 'package:pinpoint/widgets/time_distance_text.dart';
import 'package:provider/provider.dart';

class PostItem extends StatefulWidget {
  final dynamic postObject;
  final bool isInComment;
  const PostItem(
      {super.key, required this.postObject, required this.isInComment});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  var distance = 'Calculating...';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        if (!widget.isInComment) {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    CommentSection(postData: widget.postObject)),
          );
        }
      }),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
        child: Container(
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
                widget.postObject["text"],
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              // IMAGE
              if (widget.postObject["image"] != "")
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image(
                        width: MediaQuery.of(context).size.width * 0.75,
                        image: AssetImage(widget.postObject["image"]),
                      ),
                    ),
                  ),
                ),
              // AUTHOR
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  "${widget.postObject["is_anonymous"] ? "Anónimo" : widget.postObject["username"]}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
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
                        child: TimeDistanceText(postObject: widget.postObject)),
                    const Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.share,
                        size: 20,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            Icons.comment_outlined,
                            size: 20,
                          ),
                          Text(
                            "${widget.postObject["comments_number"]}",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: _downVote,
                            child: Icon(
                              (Icons.keyboard_arrow_down_rounded),
                              size: 30,
                              color: widget.postObject["down_votes"].contains(
                                      FirebaseAuth.instance.currentUser!.uid)
                                  ? const Color(0xFFFF7A06)
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            "${_getVotesNumber()}",
                            style: const TextStyle(fontSize: 20),
                          ),
                          GestureDetector(
                            onTap: _upVote,
                            child: Icon(
                              (Icons.keyboard_arrow_up_rounded),
                              size: 30,
                              color: widget.postObject["up_votes"].contains(
                                      FirebaseAuth.instance.currentUser!.uid)
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
      ),
    );
  }

  _getVotesNumber() {
    var votes = widget.postObject["up_votes"].length -
        widget.postObject["down_votes"].length;
    return votes.toString();
  }

  _downVote() async {
    if (widget.postObject["down_votes"]
        .contains(FirebaseAuth.instance.currentUser!.uid)) {
      await context.read<PostsProvider>().removeDownVotePost(widget.postObject);
    } else {
      // print('IN ELSE, NOT DOWNVOTED');
      await context.read<PostsProvider>().removeUpVotePost(widget.postObject);
      await context.read<PostsProvider>().downVotePost(widget.postObject);
    }
    return;
  }

  _upVote() async {
    if (widget.postObject["up_votes"]
        .contains(FirebaseAuth.instance.currentUser!.uid)) {
      await context.read<PostsProvider>().removeUpVotePost(widget.postObject);
    } else {
      // print('IN ELSE, NOT upVOTED');
      await context.read<PostsProvider>().removeDownVotePost(widget.postObject);
      await context.read<PostsProvider>().upVotePost(widget.postObject);
    }
    return;
  }
}
