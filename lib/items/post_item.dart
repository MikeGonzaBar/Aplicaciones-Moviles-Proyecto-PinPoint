import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {
  final postObject;
  const PostItem({super.key, required this.postObject});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 8.0, right: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 229, 231, 233),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                postObject["text"],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            if (postObject["image"] != "")
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(postObject["image"]),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 5),
              child: Text(
                "${postObject["anonymous"] ? "Anónimo" : "Martha Y"}",
                style: TextStyle(fontWeight: FontWeight.w500),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0, top: 5, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 5,
                    child: Row(
                      children: [
                        Text(
                          "📍${postObject["closeness"]} • ${postObject["timestamp"]}",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Icon(
                          Icons.share,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Icon(
                          Icons.comment_outlined,
                          size: 20,
                        ),
                        Text("${postObject["commentsNumber"]}"),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Icon(
                          (Icons.keyboard_arrow_down_rounded),
                          size: 20,
                          color: postObject["myVote"] == "down"
                              ? Color(0xFFFF7A06)
                              : Colors.black,
                        ),
                        Text("${postObject["votes"]}"),
                        Icon(
                          (Icons.keyboard_arrow_up_rounded),
                          size: 20,
                          color: postObject["myVote"] == "up"
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
