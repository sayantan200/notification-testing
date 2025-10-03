import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'notice.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    print('HomePage build method called');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification App'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //button to show notification
            ElevatedButton(
                onPressed: () async {
                  await Notice().showNotification(
                    title: 'Hello',
                    body: 'This is a test notification',
                  );
                },
                child: const Text('Show Notification')),

            const SizedBox(height: 20),

            //button to test immediate notification
            ElevatedButton(
                onPressed: () async {
                  await Notice().showNotification(
                    title: 'Test Notification',
                    body: 'This is an immediate test notification',
                  );
                },
                child: const Text('Test Immediate Notification')),

            const SizedBox(height: 20),

            //button to test multiple immediate notifications
            ElevatedButton(
                onPressed: () async {
                  for (int i = 1; i <= 3; i++) {
                    await Notice().showNotification(
                      title: 'Test Notification $i',
                      body: 'This is test notification number $i',
                    );
                    await Future.delayed(const Duration(milliseconds: 500));
                  }
                },
                child: const Text('Test Multiple Notifications')),

            const SizedBox(height: 20),

            //button to schedule notification
            ElevatedButton(
                onPressed: () async {
                  // Schedule for 2 minutes from now for testing
                  final now = DateTime.now();
                  final futureTime = now.add(const Duration(minutes: 2));

                  await Notice().scheduleNotification(
                    title: 'Scheduled Notification',
                    body: 'This is a scheduled test notification',
                    hour: futureTime.hour,
                    minute: futureTime.minute,
                  );
                },
                child: const Text('Schedule Notification')),

            const SizedBox(height: 20),

            //button to check pending notifications
            ElevatedButton(
                onPressed: () async {
                  final pendingNotifications =
                      await Notice().getPendingNotifications();
                  print(
                      'Total pending notifications: ${pendingNotifications.length}');
                  for (var notification in pendingNotifications) {
                    print(
                        'Pending notification ID: ${notification.id}, Title: ${notification.title}');
                  }
                },
                child: const Text('Check Pending Notifications')),

            const SizedBox(height: 20),

            //button to cancel all notifications
            ElevatedButton(
                onPressed: () async {
                  await Notice().cancelAllScheduledNotifications();
                  print('All notifications cancelled');
                },
                child: const Text('Cancel All Notifications')),

            const SizedBox(height: 20),

            //button to test 10-second notification
            ElevatedButton(
                onPressed: () async {
                  await Notice().scheduleNotificationWithDelay(
                    id: 10,
                    title: '10 Second Test',
                    body: 'This should appear in 10 seconds',
                    delay: const Duration(seconds: 10),
                  );
                },
                child: const Text('Test 10-Second Notification')),

            const SizedBox(height: 20),

            //button to test 30-second notification (more reliable)
            ElevatedButton(
                onPressed: () async {
                  await Notice().scheduleNotificationWithDelay(
                    id: 30,
                    title: '30 Second Test',
                    body: 'This should appear in 30 seconds (more reliable)',
                    delay: const Duration(seconds: 30),
                  );
                },
                child: const Text('Test 30-Second Notification')),

            const SizedBox(height: 20),

            //button to test web notifications
            ElevatedButton(
                onPressed: () async {
                  // For web, we'll use a simple alert as notification
                  if (kIsWeb) {
                    print(
                        'Web notification: This would show a browser notification');
                    // In a real web app, you'd request notification permission and show browser notifications
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Web notification: This is how notifications work on web'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } else {
                    await Notice().showNotification(
                      title: 'Web Test',
                      body: 'This is a test notification',
                    );
                  }
                },
                child: const Text('Test Web Notifications')),
          ],
        ),
      ),
    );
  }
}
