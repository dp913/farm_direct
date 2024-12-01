// lib/splash_screen.dart
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the LoginScreen after a delay
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Center content (logo and app name)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo or App Icon
                  Icon(
                    Icons.agriculture,
                    size: 100.0,
                    color: Colors.white,
                  ),
                  SizedBox(height: 20),
                  // App Name
                  Text(
                    'FarmDirect',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Loading indicator a little above the bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 100.0), // Adjust this to move it up
            child: CircularProgressIndicator(
              color: Colors.white, // White loading indicator
            ),
          ),
        ],
      ),
    );
  }
}
