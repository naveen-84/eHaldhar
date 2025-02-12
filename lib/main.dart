import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'language_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is ready
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LanguagePage(),
    );
  }
}
