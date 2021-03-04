import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:notification/notification.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _alarmUri = 'Unknown';
  String _ringToneUri = 'Unknown';
  String _notificationUri = 'Unknown';
  String _timeZoneName = 'Unknown';
  String _drawableUri = 'Unknown';
  String _currentAppPackageName = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await NotificationService.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    String alarmUri;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      alarmUri = await NotificationService.getAlarmUri();
    } on PlatformException {
      alarmUri = 'Failed to get platform version.';
    }

    String ringToneUri;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      ringToneUri = await NotificationService.getRingToneUri();
    } on PlatformException {
      ringToneUri = 'Failed to get platform version.';
    }

    String notificationUri;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      notificationUri = await NotificationService.getNotificationUri();
    } on PlatformException {
      notificationUri = 'Failed to get platform version.';
    }

    String timeZoneName;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      timeZoneName = await NotificationService.getTimeZoneName();
    } on PlatformException {
      timeZoneName = 'Failed to get platform version.';
    }

    String drawableUri;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      drawableUri = await NotificationService.drawableToUri('ic_launcher');
    } on PlatformException {
      drawableUri = 'Failed to get platform version.';
    }

    String currentAppPackageName;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      currentAppPackageName = await NotificationService.getCurrentAppPackageName();
    } on PlatformException {
      currentAppPackageName = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _alarmUri = alarmUri;
      _ringToneUri = ringToneUri;
      _notificationUri = notificationUri;
      _timeZoneName = timeZoneName;
      _drawableUri = drawableUri;
      _currentAppPackageName = currentAppPackageName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              Text('alarmUri: $_alarmUri\n'),
              Text('ringToneUri: $_ringToneUri\n'),
              Text('notificationUri: $_notificationUri\n'),
              Text('timeZoneName: $_timeZoneName\n'),
              Text('drawableUri: $_drawableUri\n'),
              Text('currentAppPackageName: $_currentAppPackageName\n'),
            ],
          ),
        ),
      ),
    );
  }
}
