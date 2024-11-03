// lib/signup_screen.dart
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String firstName = '';
  String lastName = '';
  String userType = 'Consumer'; // Default selection
  String phoneNumber = '';
  String? email;
  bool otpSent = false;

  void _sendOTP() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        otpSent = true;
      });
      // Here, implement the OTP sending logic as per your requirements
      print('OTP sent to $phoneNumber');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Name
              TextFormField(
                decoration: InputDecoration(labelText: 'First Name'),
                onChanged: (value) => firstName = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              // Last Name
              TextFormField(
                decoration: InputDecoration(labelText: 'Last Name'),
                onChanged: (value) => lastName = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // User Type - Farmer or Consumer
              Text("Are you a farmer or a consumer?"),
              Row(
                children: [
                  Radio(
                    value: 'Farmer',
                    groupValue: userType,
                    onChanged: (value) {
                      setState(() {
                        userType = value!;
                      });
                    },
                  ),
                  Text('Farmer'),
                  SizedBox(width: 20),
                  Radio(
                    value: 'Consumer',
                    groupValue: userType,
                    onChanged: (value) {
                      setState(() {
                        userType = value!;
                      });
                    },
                  ),
                  Text('Consumer'),
                ],
              ),
              SizedBox(height: 20),

              // Phone Number
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                onChanged: (value) => phoneNumber = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              // Send OTP Button
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _sendOTP,
                    child: Text('Send OTP'),
                  ),
                  if (otpSent)
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        'OTP Sent!',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20),

              // Email (Optional)
              TextFormField(
                decoration: InputDecoration(labelText: 'Email (optional)'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => email = value,
              ),
              SizedBox(height: 20),

              // Sign Up Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Implement sign-up logic here
                      print('Sign-up data: $firstName $lastName, $userType, $phoneNumber, $email');
                    }
                  },
                  child: Text('Sign Up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
