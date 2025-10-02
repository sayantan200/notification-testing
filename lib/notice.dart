import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notice {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  //Intialize
  Future<void> initNotification() async {
    if (_isInitialized) {
      return; // prevent multiple initialization
    }

    //prepare android init settings
    const initSttingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    //prepare  ios init setting
    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    //intt setting
    const initSettings = InitializationSettings(
      android: initSttingsAndroid,
      iOS: initSettingsIOS,
    );

    //finally initialize the plugin
    await notificationsPlugin.initialize(initSettings);

    // Request permissions for Android 13+
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _isInitialized = true;
  }

  //Notifications detail setup
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
          'daily_channel_id', 'daily_channel_name',
          channelDescription: 'daily_channel_description',
          importance: Importance.max,
          priority: Priority.high),
      iOS: DarwinNotificationDetails(),
    ); //iOS Notification Details
  }

  //show notification
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notificationsPlugin.show(id, title, body, notificationDetails());
  }
  //On notification tap
}
