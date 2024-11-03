// lib/main.dart
import 'package:farm_direct/signup_screen.dart';
import 'package:flutter/material.dart';
import 'consumer_home_screen.dart';

void main() {
  runApp(FarmDirectApp());
}

class FarmDirectApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmDirect',
      theme: ThemeData(
        primaryColor: Colors.green,
      ),
      home: SignupScreen(),
    );
  }
}
