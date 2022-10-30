import 'package:flutter/material.dart';

class EndOfScrollItem extends StatelessWidget {
  const EndOfScrollItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Text("•"),
      ),
    );
  }
}
