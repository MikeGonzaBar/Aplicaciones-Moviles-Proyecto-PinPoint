import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimeDistanceText extends StatefulWidget {
  final dynamic postObject;
  const TimeDistanceText({super.key, required this.postObject});

  @override
  State<TimeDistanceText> createState() => _TimeDistanceTextState();
}

class _TimeDistanceTextState extends State<TimeDistanceText> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getProximity(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            "📍 ${snapshot.data ?? ''} \n⏰ ${timeago.format(widget.postObject["date"].toDate())}",
            style: const TextStyle(fontWeight: FontWeight.w600),
          );
        } else {
          return const Text('📍...\n⏰...',
              style: TextStyle(fontWeight: FontWeight.w600));
        }
      },
    );
  }

  Future<String> _getProximity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var distanceInMeters = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      widget.postObject["latitude"],
      widget.postObject["longitude"],
    );

    String response = distanceInMeters <= 500
        ? 'Close to you'
        : distanceInMeters > 500 && distanceInMeters <= 1000
            ? '500 - 1km from you'
            : distanceInMeters > 1000 && distanceInMeters <= 2000
                ? '1 - 1km'
                : '2+ km from you';

    return response;
  }
}
