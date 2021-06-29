import 'package:flutter/material.dart';
import 'package:jsonparsing/ui/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Earthquake app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(title: 'Weather'),
    );
  }
}

