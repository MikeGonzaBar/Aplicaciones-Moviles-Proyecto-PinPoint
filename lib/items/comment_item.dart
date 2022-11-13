import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinpoint/providers/comments_provider.dart';
import 'package:provider/provider.dart';

class CommentItem extends StatefulWidget {
  final dynamic commentData;
  const CommentItem({super.key, required this.commentData});

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
      child: Container(
        // Grey box
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xffe8eaed),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.commentData["text"]),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "${widget.commentData["username"]}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          textAlign: TextAlign.start,
                        ),
                      )),
                  const Spacer(
                    flex: 4,
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
                            color: widget.commentData["down_votes"].contains(
                                    FirebaseAuth.instance.currentUser!.uid)
                                ? const Color(0xFFFF7A06)
                                : Colors.black,
                          ),
                        ),
                        Text(
                          _getVotesNumber(),
                          style: const TextStyle(fontSize: 20),
                        ),
                        GestureDetector(
                          onTap: _upVote,
                          child: Icon(
                            (Icons.keyboard_arrow_up_rounded),
                            size: 30,
                            color: widget.commentData["up_votes"].contains(
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
    );
  }

  String _getVotesNumber() {
    var votes = widget.commentData["up_votes"].length -
        widget.commentData["down_votes"].length;
    return votes.toString();
  }

  Future<void> _downVote() async {
    if (widget.commentData["down_votes"]
        .contains(FirebaseAuth.instance.currentUser!.uid)) {
      await context
          .read<CommentsProvider>()
          .removeDownVoteComment(widget.commentData);
    } else {
      await context
          .read<CommentsProvider>()
          .removeUpVoteComment(widget.commentData);
      if (!mounted) return;
      await context
          .read<CommentsProvider>()
          .downVoteComment(widget.commentData);
    }
    return;
  }

  Future<void> _upVote() async {
    if (widget.commentData["up_votes"]
        .contains(FirebaseAuth.instance.currentUser!.uid)) {
      await context
          .read<CommentsProvider>()
          .removeUpVoteComment(widget.commentData);
    } else {
      await context
          .read<CommentsProvider>()
          .removeDownVoteComment(widget.commentData);
      if (!mounted) return;
      await context.read<CommentsProvider>().upVoteComment(widget.commentData);
    }
    return;
  }
}
