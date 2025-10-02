import 'package:flutter/material.dart';
import 'home_page.dart';
import 'notice.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //init notification
  await Notice().initNotification();

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
