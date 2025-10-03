import 'package:flutter/material.dart';
import 'home_page.dart';
import 'notice.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications in background to not block app startup
  Notice().initNotification().catchError((e) {
    print('Notification initialization failed: $e');
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
