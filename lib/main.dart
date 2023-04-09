import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoflutter/pages/habit_tracker_page.dart';
import 'package:todoflutter/pages/login_page.dart';
import 'pages/notes_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('mybox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      theme: ThemeData(primarySwatch: Colors.grey),
      routes: {
        'login_page': (context) => LoginPage(),
        'note_page': (context) => const NotePage(),
        'habit_page': (context) => const HabitPage(),
      },
    );
  }
}
