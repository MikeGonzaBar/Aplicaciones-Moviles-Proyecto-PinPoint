import 'package:flutter/material.dart';

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final txtController = TextEditingController();
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
                    controller: txtController,
                    maxLines: 3,
                    style: TextStyle(fontWeight: FontWeight.w600),
                    cursorColor: Color(0xFF009fb7),
                    decoration: InputDecoration(
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
                Text(
                  "Publish anonymously",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Switch(
                  value: isAnon,
                  onChanged: (value) {
                    setState(() {
                      isAnon = value;
                      print(isAnon);
                    });
                  },
                  activeTrackColor: Color.fromARGB(255, 145, 200, 209),
                  activeColor: Color(0xFF009fb7),
                  inactiveTrackColor: Color(0xffe8eaed),
                  inactiveThumbColor: Color(0xFF8492A6),
                ),
              ],
            ),
            Text("Publish for:", style: TextStyle(fontWeight: FontWeight.w600)),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        daysActive = 1;
                        print(isAnon);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(100, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // <-- Radius
                      ),
                      backgroundColor: daysActive == 1
                          ? Color(0xFF009fb7)
                          : Color(0xFFC0CCDA),
                    ),
                    child: Text("1 dia"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        daysActive = 7;
                        print(isAnon);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(100, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // <-- Radius
                      ),
                      backgroundColor: daysActive == 7
                          ? Color(0xFF009fb7)
                          : Color(0xFFC0CCDA),
                    ),
                    child: Text("7 dias"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        daysActive = 15;
                        print(isAnon);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(100, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // <-- Radius
                      ),
                      backgroundColor: daysActive == 15
                          ? Color(0xFF009fb7)
                          : Color(0xFFC0CCDA),
                    ),
                    child: Text("15 dias"),
                  ),
                ],
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(100, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // <-- Radius
                  ),
                  backgroundColor: Color(0xFF009fb7),
                ),
                child: Text("Publish"),
              ),
            ),
          ],
        ));
  }
}
