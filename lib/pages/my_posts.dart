import 'package:flutter/material.dart';
import 'package:pinpoint/items/post_item.dart';
import '../temp_data.dart' as temp_data;

class MyPosts extends StatelessWidget {
  const MyPosts({super.key});
  @override
  Widget build(BuildContext context) {
    // padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                Text(
                  "Martha Y",
                  style: TextStyle(fontSize: 35),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    "Usuario desde hace 1m",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    "¡Has recolectado 95 likes!",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    "Tus PinPoints más recientes:",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: temp_data.myPostsList.length,
            itemBuilder: (BuildContext context, int index) {
              return PostItem(
                postObject: temp_data.myPostsList[index],
              );
            },
          )
        ],
      ),
    );
  }
}
