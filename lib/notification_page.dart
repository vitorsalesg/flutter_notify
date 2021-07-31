import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final oneSignalKey = "KEY";
  final restApiKey = "KEY";

  @override
  void initState() {
    super.initState();
    initOneSignal();
  }

  Future<void> initOneSignal() async {
    //Started OneSignal
    OneSignal.shared.setAppId(oneSignalKey);

    // Will be called whenever a notification is received in foreground
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) {
        print('Receive notification');
        print('Titulo: ${event.notification.title}');
        print('Body: ${event.notification.body}');
      },
    );

    //OnClicked Notification
    OneSignal.shared.setNotificationOpenedHandler(
      (OSNotificationOpenedResult result) {
        print('OnClicked Notification');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: Text('Flutter Notify - OneSignal'),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications, size: 100),
            const SizedBox(height: 10),
            buttonWigdet(
              title: 'Send To Specific User',
              onClicked: () => _sendNotification(false),
            ),
            buttonWigdet(
              title: 'Send To All User',
              onClicked: () => _sendNotification(true),
            ),
            buttonWigdet(
              title: 'Get User ID',
              onClicked: () async {
                //Get informations Phone
                var status = await OneSignal.shared.getDeviceState();
                print(status!.userId);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonWigdet({
    required String title,
    required VoidCallback onClicked,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue[100]),
          ),
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: onClicked,
        ),
      ),
    );
  }

  Future<void> _sendNotification(bool sendToAll) async {
    Dio dio = Dio();

    var specific = {
      "app_id": oneSignalKey,
      "include_external_user_ids": ["KEY-USER"],
      "channel_for_external_user_ids": "push",
      "data": {"foo": "bar"},
      "headings": {"en": "heading"},
      "contents": {"en": "contents"}
    };

    var all = {
      "included_segments": ["Subscribed Users"],
      "app_id": oneSignalKey,
      "headings": {"en": "heading"},
      "contents": {"en": "contents"},
      "data": {"en": "teste message"}
    };

    var response = await dio.post(
      "https://onesignal.com/api/v1/notifications",
      data: jsonEncode(sendToAll ? all : specific),
      options: Options(
        headers: {
          "Authorization": "Basic {{$restApiKey}}",
          "Content-Type": "application/json",
        },
      ),
    );

    print(response.statusCode);
    print(response.statusMessage);
  }
}
