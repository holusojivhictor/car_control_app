import 'package:flutter/material.dart';
import 'package:gigi_control_app/screens/home_screen.dart';

void main() {
  runApp(const CarControlApp());
}

class CarControlApp extends StatelessWidget {
  const CarControlApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Control App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const HomeScreen(),
    );
  }
}