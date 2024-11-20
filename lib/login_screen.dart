// lib/login_screen.dart
import 'package:flutter/material.dart';
import 'farmer_dashboard_screen.dart'; // Assuming this is the FarmerDashboardScreen you created earlier
import 'consumer_home_screen.dart'; // Assuming this is the HomeScreen for consumers

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Sample login credentials for farmer and consumer
  final String farmerPhone = "1234567890";
  final String farmerPassword = "farmer";
  final String consumerPhone = "9876543210";
  final String consumerPassword = "consumer";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phone Number:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(hintText: 'Enter your phone number'),
            ),
            SizedBox(height: 20),
            Text('Password:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(hintText: 'Enter your password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  void _login() {
    final phone = _phoneController.text;
    final password = _passwordController.text;

    // Check if the phone and password match for farmer or consumer
    if (phone == farmerPhone && password == farmerPassword) {
      // Navigate to the Farmer Dashboard screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FarmerDashboardScreen()),
      );
    } else if (phone == consumerPhone && password == consumerPassword) {
      // Navigate to the Consumer Home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // Show an error message if the login is incorrect
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Invalid phone number or password.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
