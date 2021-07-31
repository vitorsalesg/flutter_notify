import 'package:flutter/material.dart';
import 'notification_page.dart';

void main() => runApp(AppWidget());

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notify',
      debugShowCheckedModeBanner: false,
      home: NotificationPage(),
    );
  }
}
