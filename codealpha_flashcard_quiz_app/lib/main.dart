
import 'package:flutter/material.dart';
import 'home.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',

      home: Scaffold(
        appBar: AppBar(title: const Text('Quiz App')),
        body: Homme_Screen(),
      ),
    );
  }
}

