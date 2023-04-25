// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_push_notification/model/pushnotification_model.dart';
import 'package:flutter_push_notification/notificationBadge.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // initialize some values
  late final FirebaseMessaging messaging;
  late int totalNotificationCounter;
  // model
  PushNotification? notificationInfo;

  // register notification
  void registerNotification() async {
    await Firebase.initializeApp();
    // instance for firebase messaging
    messaging = FirebaseMessaging.instance;

    // three type of state in notification
    // not determined (null), granted (true) and decline (false)

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted the permission");

      // main message

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        PushNotification notification = PushNotification(
          title: message.notification!.title,
          body: message.notification!.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );
        setState(() {
          totalNotificationCounter++;
          notificationInfo = notification;
        });

        if (notification != null) {
          showSimpleNotification(Text(notificationInfo!.title!),
              leading:
                  NotificationBadge(totalNotifcation: totalNotificationCounter),
              subtitle: Text(notificationInfo!.body!),
              background: Colors.cyan.shade700,
              duration: Duration(seconds: 2));
        }
      });
    } else {
      print("Permission declined by user");
    }
  }

  @override
  void initState() {
    registerNotification();
    totalNotificationCounter = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PushNotification")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "FlutterPushNotification",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            SizedBox(height: 15),
            // showing a notification badge which will
            // count the total notification that we received
            NotificationBadge(totalNotifcation: totalNotificationCounter),
            SizedBox(height: 30),

            // if notificationInfo is not null
            notificationInfo != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          "TITLE: ${notificationInfo!.dataTitle ?? notificationInfo!.title}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 9),
                      Text(
                          "BODY: ${notificationInfo!.dataBody ?? notificationInfo!.body}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
