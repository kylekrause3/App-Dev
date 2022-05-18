import 'package:fitness_tracker/MyHomePage.dart';
import 'package:fitness_tracker/RandomWords.dart';
import 'package:flutter/material.dart';

import 'FitStopwatch.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      //home: const RandomWords(),
      home: const FitStopwatch(),
    );
  }
}