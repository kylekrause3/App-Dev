import 'package:fitness_tracker/MyHomePage.dart';
import 'package:fitness_tracker/RandomWords.dart';
import 'package:flutter/material.dart';
import 'database_handler.dart';

import 'FitStopwatch.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB();
  }

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
/*
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
    this.handler.initializeDB();
  }

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
}*/
