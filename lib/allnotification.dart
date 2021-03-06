import 'dart:async';

import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// The service used to display notifications and handle callbacks when the user taps on the notification.
/// This is a singleton. Just call Notification() to get the singleton.
class AllNotification {
  static const MethodChannel _channel = const MethodChannel('allnotification');

  static final AllNotification _instance = AllNotification._internal();

  factory AllNotification() => _instance;

  FlutterLocalNotificationsPlugin plugin;

  AllNotification._internal() {
    final initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'), iOS: IOSInitializationSettings());

    plugin = FlutterLocalNotificationsPlugin();
    plugin.initialize(initializationSettings);
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// this calls a method over a platform channel implemented within the
  /// plugin to return the Uri for the default alarm sound and uses
  /// as the notification sound
  static Future<String> getAlarmUri() async {
    final String alarmUri = await _channel.invokeMethod('getAlarmUri');
    return alarmUri;
  }

  /// this calls a method over a platform channel implemented within the
  /// plugin to return the Uri for the default ringtone sound and uses
  /// as the notification sound
  static Future<String> getRingToneUri() async {
    final String ringtoneUri = await _channel.invokeMethod('getRingToneUri');
    return ringtoneUri;
  }

  /// this calls a method over a platform channel implemented within the
  /// plugin to return the Uri for the default notification sound and uses
  /// as the notification sound
  static Future<String> getNotificationUri() async {
    final String notificationUri = await _channel.invokeMethod('getNotificationUri');
    return notificationUri;
  }

  /// this calls a method over a platform channel implemented within the
  /// plugin to return the default timezone name and uses
  /// as the timezone name
  static Future<String> getTimeZoneName() async {
    final String timeZoneName = await _channel.invokeMethod('getTimeZoneName');
    return timeZoneName;
  }

  // use a platform channel to resolve an Android drawable resource to a URI.
  // Calls made over this channel is handled by the app
  static Future<String> drawableToUri(String drawable) async {
    final String imageUri = await _channel.invokeMethod('drawableToUri', drawable);
    return imageUri;
  }

  // use a platform channel to get package name of the App calling this plugin.
  // Calls made over this channel is handled by the App
  static Future<String> getCurrentAppPackageName() async {
    final String _packageName = await _channel.invokeMethod('getCurrentAppPackageName');
    return _packageName;
  }

  //restarts the app at the activity level
  static Future<bool> restartApp() async {
    final result = await _channel.invokeMethod('restartApp');
    return result;
  }

  FlutterLocalNotificationsPlugin get local => plugin;

  //[Importance] and [Priority] can be accessed by importing the below package in your project like so:
  //import package:flutter_local_notifications/src/platform_specifics/android/enums.dart
  Future<void> newNotification(String channelId, String channelName, String channelDescription, String title,
      String body, bool vibration, int hashCode,
      {bool indeterminateProgressBar = false,
      bool usesChronometer = false,
      bool autoCancel = true,
      bool playSound = false,
      bool enableLights = true,
      Importance importance = Importance.defaultImportance,
      Priority priority = Priority.defaultPriority,
      bool showProgress = false,
      int maxProgress = 0,
      int progress = 0,
      int timeoutAfter,
      Color color = const Color.fromARGB(155, 155, 0, 255),
      Color ledColor = const Color.fromARGB(255, 255, 0, 0)}) async {
    // Define vibration pattern
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidChannel = AndroidNotificationDetails(channelId, channelName, channelDescription,
        //sound: RawResourceAndroidNotificationSound('slow_spring_board'),
        importance: importance,
        priority: priority,
        progress: progress,
        maxProgress: maxProgress,
        showProgress: showProgress,
        usesChronometer: usesChronometer,
        vibrationPattern: vibration ? vibrationPattern : null,
        playSound: playSound,
        autoCancel: autoCancel,
        timeoutAfter: timeoutAfter,
        indeterminate: indeterminateProgressBar,
        enableLights: enableLights,
        enableVibration: vibration,
        color: color,
        ledColor: ledColor,
        ledOnMs: 1000,
        ledOffMs: 500);

    var iosChannel = IOSNotificationDetails(presentSound: true);
    var platformChannel = NotificationDetails(android: androidChannel, iOS: iosChannel);

    try {
      await plugin.show(
        0 /* hashCode */,
        title,
        body,
        platformChannel,
        payload: hashCode.toString(),
      );
    } catch (ex) {
      print(ex);
    }
  }

  //[Importance] and [Priority] can be accessed by importing the below package in your project like so:
  //import package:flutter_local_notifications/src/platform_specifics/android/enums.dart
  Future<void> showSoundUriNotification(String channelId, String channelName, String channelDescription, String title,
      String body, bool vibration, int hashCode,
      {bool indeterminateProgressBar = false,
      bool usesChronometer = false,
      bool autoCancel = true,
      bool playSound = true,
      bool enableLights = true,
      Importance importance = Importance.defaultImportance,
      Priority priority = Priority.defaultPriority,
      bool showProgress = false,
      int maxProgress = 0,
      int progress = 0,
      String soundUri,
      int timeoutAfter,
      Color color = const Color.fromARGB(255, 255, 123, 255),
      Color ledColor = const Color.fromARGB(237, 25, 298, 0)}) async {
    /// this calls a method over a platform channel implemented within the
    /// app to return the Uri for the default alarm sound and uses
    /// as the notification sound
    final String alarmUri = await getAlarmUri();
    final UriAndroidNotificationSound uriSound = UriAndroidNotificationSound(soundUri ?? alarmUri);

    // Define vibration pattern
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidChannel = AndroidNotificationDetails(channelId, channelName, channelDescription,
        //sound: RawResourceAndroidNotificationSound('slow_spring_board'),
        importance: importance,
        priority: priority,
        progress: progress,
        maxProgress: maxProgress,
        showProgress: showProgress,
        usesChronometer: usesChronometer,
        vibrationPattern: vibration ? vibrationPattern : null,
        styleInformation: const DefaultStyleInformation(true, true),
        playSound: playSound,
        autoCancel: autoCancel,
        onlyAlertOnce: false,
        indeterminate: indeterminateProgressBar,
        sound: uriSound,
        timeoutAfter: timeoutAfter,
        enableLights: enableLights,
        enableVibration: vibration,
        color: color,
        ledColor: ledColor,
        ledOnMs: 1000,
        ledOffMs: 500);

    var iosChannel = IOSNotificationDetails(presentSound: true);
    var platformChannel = NotificationDetails(android: androidChannel, iOS: iosChannel);

    try {
      await plugin.show(
        0 /* hashCode */,
        title,
        body,
        platformChannel,
        payload: hashCode.toString(),
      );
    } catch (ex) {
      print(ex);
    }
  }
}
