import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  final commentData;
  const CommentItem({super.key, required this.commentData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
      child: Container(
        // Grey box
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Color(0xffe8eaed),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(commentData["comment"]),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "${commentData["authorId"]}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          textAlign: TextAlign.start,
                        ),
                      )),
                  Spacer(
                    flex: 4,
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          (Icons.keyboard_arrow_down_rounded),
                          size: 20,
                          color: commentData["myVote"] == "down"
                              ? Color(0xFFFF7A06)
                              : Colors.black,
                        ),
                        Text("${commentData["votes"]}"),
                        Icon(
                          (Icons.keyboard_arrow_up_rounded),
                          size: 20,
                          color: commentData["myVote"] == "up"
                              ? Color(0xFFFF7A06)
                              : Colors.black,
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
}
