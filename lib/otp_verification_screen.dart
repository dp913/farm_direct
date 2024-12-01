import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'farmer_dashboard_screen.dart';
import 'consumer_home_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  OtpVerificationScreen({required this.phoneNumber});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  String? _verificationId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    print("OtpVerificationScreen initialized with phone number: ${widget.phoneNumber}");
    _sendVerificationCode();
  }

  void _sendVerificationCode() async {
    setState(() {
      _isLoading = true;
    });
    print("Sending verification code to ${widget.phoneNumber}");
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        print("Verification completed automatically, signing in...");
        // Automatically signs in the user
        await FirebaseAuth.instance.signInWithCredential(credential);
        _navigateToDashboard();
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _isLoading = false;
        });
        print("Verification failed: ${e.message}");
        _showErrorDialog(e.message ?? "Verification failed. Please try again.");
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _isLoading = false;
          _verificationId = verificationId;
        });
        print("Code sent: verificationId = $verificationId");

        // Show a SnackBar to notify that the OTP has been sent
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP has been sent to your phone.')),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
        print("Auto retrieval timeout: verificationId = $verificationId");
      },
    );
  }

  void _verifyOtp() async {
    final otp = _otpController.text.trim();
    print("Verifying OTP: $otp");

    if (_verificationId == null) {
      print("Verification ID is missing.");
      _showErrorDialog('Verification ID is missing. Please try again.');
      return;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      print("Signing in with OTP...");
      await FirebaseAuth.instance.signInWithCredential(credential);
      _navigateToDashboard();
    } catch (e) {
      print("OTP verification failed: $e");
      _showErrorDialog('Invalid OTP. Please try again.');
    }
  }

  void _navigateToDashboard() {
    print("Navigating to dashboard...");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => FarmerDashboardScreen()),
    );
  }

  void _showErrorDialog(String message) {
    print("Error: $message");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phone Number: ${widget.phoneNumber}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('Enter OTP:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              controller: _otpController,
              decoration: InputDecoration(hintText: 'Enter the OTP'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyOtp,
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
