// lib/login_screen.dart
import 'package:flutter/material.dart';
import 'farmer_dashboard_screen.dart'; // Assuming this is the FarmerDashboardScreen
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Login Heading
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 20),

              // Phone Number Field
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.phone, color: Colors.green),
                ),
              ),
              const SizedBox(height: 16),

              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.green),
                ),
              ),
              const SizedBox(height: 24),

              // Login Button
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 14), backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ), // Button color
                ),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),

              // Create Account Button
              TextButton(
                onPressed: () {
                  // Navigate to Create Account screen
                },
                child: Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Error Message Placeholder
              Text(
                '', // Use this to display error messages dynamically
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
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
