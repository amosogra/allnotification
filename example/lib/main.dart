import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:allnotification/allnotification.dart';

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

  Timer timer;
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
      platformVersion = await AllNotification.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    String alarmUri;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      alarmUri = await AllNotification.getAlarmUri();
    } on PlatformException {
      alarmUri = 'Failed to get platform version.';
    }

    String ringToneUri;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      ringToneUri = await AllNotification.getRingToneUri();
    } on PlatformException {
      ringToneUri = 'Failed to get platform version.';
    }

    String notificationUri;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      notificationUri = await AllNotification.getNotificationUri();
    } on PlatformException {
      notificationUri = 'Failed to get platform version.';
    }

    String timeZoneName;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      timeZoneName = await AllNotification.getTimeZoneName();
    } on PlatformException {
      timeZoneName = 'Failed to get platform version.';
    }

    String drawableUri;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      drawableUri = await AllNotification.drawableToUri('ic_launcher');
    } on PlatformException {
      drawableUri = 'Failed to get platform version.';
    }

    String currentAppPackageName;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      currentAppPackageName = await AllNotification.getCurrentAppPackageName();
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

    final channelName1 = 'Battery Notification Service';
    final channelName2 = 'Battery Notification Service2';

    openFileExplorerForAudio().then((path) async {
      Uri uri = Uri.file(path, windows: false);

      print('Uri path: ${uri.path}');
      print('Uri ToFilePath: ${uri.toFilePath(windows: false)}');
      print('Uri ToString: ${uri.toString()}');
      print('Uri IsAbsolute: ${uri.isAbsolute}');
 
      await AllNotification().newNotification(channelName1, channelName1, channelName1, "HeadsUp",
          "Unplug/Plug your device, your battery has reached its charging/discharging limit", true, 0,
          maxProgress: 100, progress: 50, showProgress: true);

      timer = Timer.periodic(Duration(seconds: 10), (timer) async {
        print("Timer is firing another notification..");
        await AllNotification().showSoundUriNotification(channelName2, channelName2, channelName2, "Battery Alert!",
            "Unplug/Plug your device, your battery has reached its charging/discharging limit", true, 0,
            maxProgress: 100, progress: 50, showProgress: false, soundUri: await AllNotification.getRingToneUri());
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<String> openFileExplorerForAudio() async {
    String _fileName;
    List<PlatformFile> _paths;
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }

    _fileName = _paths != null ? _paths.map((platformFile) => platformFile.name).toList()[0] : '...';
    final path = _paths != null ? _paths.map((e) => e.path).toList()[0] : null;
    return path;
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
