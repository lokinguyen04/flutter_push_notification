// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  // also take a total notification value
  final int totalNotifcation;
  const NotificationBadge({Key? key, required this.totalNotifcation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              "$totalNotifcation",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ));
  }
}
