import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {
  final postObject;
  const PostItem({super.key, required this.postObject});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // TODO: CHECK PADDING HERE
      padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffe8eaed),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MAIN TEXT
            Text(
              postObject["text"],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            // IMAGE
            if (postObject["image"] != "")
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image(
                      width: MediaQuery.of(context).size.width * 0.75,
                      image: AssetImage(postObject["image"]),
                    ),
                  ),
                ),
              ),
            // AUTHOR
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                "${postObject["anonymous"] ? "Anónimo" : postObject["author"]}",
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
                    child: Text(
                      "📍${postObject["closeness"]} • ${postObject["timestamp"]}",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
