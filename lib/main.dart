import 'package:flutter/material.dart';
import 'package:social_app/pages/home.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'Butterfly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.yellow,
      ),
      home: Home(),
    );
  }
}

