import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class Notice {
  static final Notice _instance = Notice._internal();
  factory Notice() => _instance;
  Notice._internal();

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  //Intialize
  Future<void> initNotification() async {
    if (_isInitialized) {
      return; // prevent multiple initialization
    }
    //init timezone handling
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();

    // Handle the old "Asia/Calcutta" timezone name
    String timezoneName = currentTimeZone;
    if (timezoneName == 'Asia/Calcutta') {
      timezoneName = 'Asia/Kolkata';
    }

    tz.setLocalLocation(tz.getLocation(timezoneName));

    //prepare android init settings
    const AndroidInitializationSettings initSttingsAndroid =
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
    await notificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      print('Notification tapped: ${response.payload}');
    });

    // Request permissions for Android 13+
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // Request exact alarm permission for Android 14+
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();

    // Request permissions for iOS
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

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
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
        badgeNumber: 1,
      ),
    );
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

//Schedule notification
//-hour(0-23)
//-min(0-59)

  Future<void> scheduleNotification({
    int id = 1,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    //Get the current date and time
    final now = tz.TZDateTime.now(tz.local);

    //Create a date/time for today at specified hour/minute
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    //If the scheduled time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
      print(
          'Scheduled time has passed, scheduling for tomorrow: $scheduledDate');
    } else {
      print('Scheduling notification for today: $scheduledDate');
    }

    print('Current time: $now');
    print('Scheduled time: $scheduledDate');

    // Calculate the time difference
    final timeDifference = scheduledDate.difference(now);
    print('Time until notification: ${timeDifference.inSeconds} seconds');

    //Schedule the notification
    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'scheduled_notification_$id',
    );

    print('Notification scheduled for $scheduledDate');

    // Verify the notification was scheduled (skip on web)
    try {
      final pendingNotifications =
          await notificationsPlugin.pendingNotificationRequests();
      print('Total pending notifications: ${pendingNotifications.length}');
      for (var notification in pendingNotifications) {
        print(
            'Pending notification ID: ${notification.id}, Title: ${notification.title}');
      }
    } catch (e) {
      print('Pending notifications check failed (likely on web): $e');
    }
  }

//Cancel a scheduled notification
  Future<void> cancelAllScheduledNotifications() async {
    await notificationsPlugin.cancelAll();
  }

  //Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await notificationsPlugin.pendingNotificationRequests();
    } catch (e) {
      print('Pending notifications check failed (likely on web): $e');
      return [];
    }
  }

  //Schedule notification with specific delay (for testing)
  Future<void> scheduleNotificationWithDelay({
    int id = 1,
    required String title,
    required String body,
    required Duration delay,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = now.add(delay);

    print('Current time: $now');
    print('Scheduled time: $scheduledDate');
    print('Delay: ${delay.inSeconds} seconds');

    //Schedule the notification
    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'delayed_notification_$id',
    );

    print('Notification scheduled for $scheduledDate');

    // Verify the notification was scheduled
    try {
      final pendingNotifications =
          await notificationsPlugin.pendingNotificationRequests();
      print('Total pending notifications: ${pendingNotifications.length}');
      for (var notification in pendingNotifications) {
        print(
            'Pending notification ID: ${notification.id}, Title: ${notification.title}');
      }
    } catch (e) {
      print('Pending notifications check failed (likely on web): $e');
    }
  }
}
