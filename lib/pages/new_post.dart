// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pinpoint/providers/posts_provider.dart';
import 'package:provider/provider.dart';

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final postTxtController = TextEditingController();
  bool isAnon = false;
  int daysActive = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xffe8eaed),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: postTxtController,
                    maxLines: 3,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    cursorColor: const Color(0xFF009fb7),
                    decoration: const InputDecoration(
                      labelText: 'Write your PinPoint',
                      border: InputBorder.none,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Icon(
                      Icons.image_outlined,
                      size: 30,
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Publish anonymously",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Switch(
                  value: isAnon,
                  onChanged: (value) {
                    setState(() {
                      isAnon = value;
                    });
                  },
                  activeTrackColor: const Color.fromARGB(255, 145, 200, 209),
                  activeColor: const Color(0xFF009fb7),
                  inactiveTrackColor: const Color(0xffe8eaed),
                  inactiveThumbColor: const Color(0xFF8492A6),
                ),
              ],
            ),
            const Text("Publish for:",
                style: TextStyle(fontWeight: FontWeight.w600)),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        daysActive = 1;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(100, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // <-- Radius
                      ),
                      backgroundColor: daysActive == 1
                          ? const Color(0xFF009fb7)
                          : const Color(0xFFC0CCDA),
                    ),
                    child: const Text("1 dia"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        daysActive = 7;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(100, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // <-- Radius
                      ),
                      backgroundColor: daysActive == 7
                          ? const Color(0xFF009fb7)
                          : const Color(0xFFC0CCDA),
                    ),
                    child: const Text("7 dias"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        daysActive = 15;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(100, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // <-- Radius
                      ),
                      backgroundColor: daysActive == 15
                          ? const Color(0xFF009fb7)
                          : const Color(0xFFC0CCDA),
                    ),
                    child: const Text("15 dias"),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  // Validate input
                  if (daysActive == 0 || postTxtController.text == '') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                            'All posts need a message and time limit.'),
                        action: SnackBarAction(
                          label: 'Ok',
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();
                          },
                        ),
                      ),
                    );
                  } else {
                    _publish();
                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(100, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // <-- Radius
                  ),
                  backgroundColor: const Color(0xFF009fb7),
                ),
                child: const Text("Publish"),
              ),
            ),
          ],
        ));
  }

  Future<void> _publish() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    dynamic postObj = {
      "text": postTxtController.text,
      "isAnon": isAnon,
      "daysActive": daysActive,
      "location": position,
    };
    if (await context.read<PostsProvider>().addNewPost(postObj) == true) {
      // If post submission was successful
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('New post created!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'OK');
                // Return to Feed
                postTxtController.clear();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // If post submission was not successful
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'There was an issue sending your post. Please try again.'),
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
}
