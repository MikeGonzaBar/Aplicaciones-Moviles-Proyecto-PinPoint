import 'package:flutter/material.dart';
import 'package:pinpoint/items/comment_item.dart';
import '../items/end_of_scroll_item.dart';
import '../temp_data.dart' as temp_data;

class CommentSection extends StatelessWidget {
  final postData;
  const CommentSection({super.key, required this.postData});

  @override
  Widget build(BuildContext context) {
    final commentController = TextEditingController();
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
                          padding: EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Color(0xffe8eaed),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // MAIN TEXT
                              Text(
                                postData["text"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              // IMAGE
                              if (postData["image"] != "")
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.75,
                                        image: AssetImage(postData["image"]),
                                      ),
                                    ),
                                  ),
                                ),
                              // AUTHOR
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  "${postData["anonymous"] ? "Anónimo" : postData["author"]}",
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
                                      child: Text(
                                        "📍${postData["closeness"]} • ${postData["timestamp"]}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            Icons.comment_outlined,
                                            size: 20,
                                          ),
                                          Text("${postData["commentsNumber"]}"),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            (Icons.keyboard_arrow_down_rounded),
                                            size: 20,
                                            color: postData["myVote"] == "down"
                                                ? Color(0xFFFF7A06)
                                                : Colors.black,
                                          ),
                                          Text("${postData["votes"]}"),
                                          Icon(
                                            (Icons.keyboard_arrow_up_rounded),
                                            size: 20,
                                            color: postData["myVote"] == "up"
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
                        // COMMENT TEXT DIVIDER
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Comentarios:"),
                        ),
                        // COMMENT CONTAINER
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: temp_data.comments.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index != temp_data.comments.length) {
                              return CommentItem(
                                  commentData: temp_data.comments[index]);
                            } else {
                              // If index is last, add ending dot
                              return EndOfScrollItem();
                            }
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
                child: Container(
                  // color: Colors.red,
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: "Comment something...",
                      // label: Text("Hello"),
                      // labelText: "Comment something...",
                      filled: true,
                      fillColor: const Color(0xfffafafa),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {},
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
}
