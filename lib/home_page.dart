import 'package:flutter/material.dart';
import 'notice.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              await Notice().showNotification(
                title: 'Hello',
                body: 'This is a test notification',
              );
            },
            child: const Text('Show Notification')),
      ),
    );
  }
}
