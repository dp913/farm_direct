// lib/profile_management_screen.dart
import 'package:flutter/material.dart';

class ProfileManagementScreen extends StatelessWidget {
  final Map<String, String> farmerProfile = {
    'name': 'John Doe',
    'address': 'Green Valley, Ontario',
    'contact': '+1 234 567 890',
    'email': 'john.doe@example.com',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(farmerProfile['name'] ?? '', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Address:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(farmerProfile['address'] ?? '', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Contact:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(farmerProfile['contact'] ?? '', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Email:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(farmerProfile['email'] ?? '', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logic to edit profile
              },
              child: Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
