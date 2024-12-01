// lib/login_screen.dart

import 'package:farm_direct/signup_screen.dart';
import 'package:flutter/material.dart';
import 'consumer_home_screen.dart';
import 'farmer_dashboard_screen.dart';
import 'otp_verification_screen.dart'; // Import the OTP screen
import 'farmer_dashboard_screen.dart'; // Assuming this is the FarmerDashboardScreen
import 'consumer_home_screen.dart'; // Assuming this is the HomeScreen for consumers

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  // Variable to toggle password visibility
  bool _passwordVisible = false;

  // Sample login credentials for farmer, consumer, and the new user
  final String farmerPhone = "+11234567890";  // Adjusted with +1

  final String farmerPassword = "farmer";
  final String consumerPhone = "+19876543210";  // Adjusted with +1
  final String consumerPassword = "consumer";
  final String newUserPhone = "+14377667036";  // New user phone number with +1
  final String newUserPassword = "kush";    // New user password

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

              // Password Field with Eye Icon
              TextField(
                controller: _passwordController,
                obscureText: !_passwordVisible, // Toggle visibility
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.green),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible; // Toggle state
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Login Button
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 14),
                  backgroundColor: Colors.green,
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
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );

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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Login'),
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text('Phone Number:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //           TextField(
  //             controller: _phoneController,
  //             decoration: InputDecoration(hintText: 'Enter your phone number'),
  //           ),
  //           SizedBox(height: 20),
  //           Text('Password:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //           TextField(
  //             controller: _passwordController,
  //             obscureText: true,
  //             decoration: InputDecoration(hintText: 'Enter your password'),
  //           ),
  //           SizedBox(height: 20),
  //           ElevatedButton(
  //             onPressed: _navigateToOtpVerification,
  //             child: Text('Next'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // void _navigateToOtpVerification() {
  //   final phone = _phoneController.text;
  //   final password = _passwordController.text;
  //
  //   // Ensure +1 is added to the number if it's the special case for new user
  //   String formattedPhone = phone;
  //
  //   if (phone == "4377667036") {
  //     formattedPhone = "+1$phone";  // Prefix with +1 for the new user phone number
  //   }
  //
  //   if (phone.isNotEmpty && password.isNotEmpty) {
  //     // Check if the phone number and password match any of the registered users
  //     if ((formattedPhone == farmerPhone && password == farmerPassword) ||
  //         (formattedPhone == consumerPhone && password == consumerPassword) ||
  //         (formattedPhone == newUserPhone && password == newUserPassword)) {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => OtpVerificationScreen(phoneNumber: formattedPhone),
  //         ),
  //       );
  //     } else {
  //       _showErrorDialog('Invalid phone number or password. Please try again.');
  //     }
  //   } else {
  //     _showErrorDialog('Please enter both phone number and password.');
  //   }
  // }

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
