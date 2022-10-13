import 'package:flutter/material.dart';

class EndOfScrollItem extends StatelessWidget {
  const EndOfScrollItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: const Center(
        child: Text("•"),
      ),
    );
  }
}
