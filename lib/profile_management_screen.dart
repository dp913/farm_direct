// lib/profile_management_screen.dart

import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import for logout navigation
import 'edit_profile_screen.dart'; // Import the edit profile screen
import 'farmer_dashboard_screen.dart';
import 'manage_produce_screen.dart';
import 'order_management_screen.dart';

class ProfileManagementScreen extends StatefulWidget {
  @override
  _ProfileManagementScreenState createState() =>
      _ProfileManagementScreenState();
}

class _ProfileManagementScreenState extends State<ProfileManagementScreen> {
  Map<String, String> farmerProfile = {
    'name': 'John Doe',
    'address': 'Green Valley, Ontario',
    'contact': '+1 234 567 890',
    'email': 'john.doe@example.com',
  };

  int _selectedIndex = 3; // Set the current tab index to Profile Management

  final List<Widget> _screens = [
    FarmerDashboardScreen(),
    ManageProduceScreen(),
    OrderManagementScreen(),
    ProfileManagementScreen(), // Self-reference for navigation consistency
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => _screens[index]),
      );
    }
  }

  void _editProfile() async {
    // Navigate to EditProfileScreen and wait for updated data
    final updatedProfile = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(profile: farmerProfile),
      ),
    );

    if (updatedProfile != null) {
      setState(() {
        farmerProfile = updatedProfile; // Update profile with new data
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Management'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/farmer_placeholder.png'),
              ),
            ),
            const SizedBox(height: 16),

            // Farmer Information
            Center(
              child: Column(
                children: [
                  Text(
                    farmerProfile['name'] ?? 'N/A',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    farmerProfile['email'] ?? 'N/A',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Account Details Section
            Text(
              'Account Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.phone, 'Phone', farmerProfile['contact'] ?? 'N/A'),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.location_on, 'Address', farmerProfile['address'] ?? 'N/A'),
            const SizedBox(height: 16),

            // Action Buttons
            const Divider(),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: _editProfile,
                icon: Icon(Icons.edit),
                label: Text('Edit Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false,
                  );
                },
                icon: Icon(Icons.logout),
                label: Text('Log Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[300],
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Contact Us Button
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () {
                  // Show an AlertDialog with contact details
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Contact Us'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.phone, color: Colors.green),
                              title: Text('Phone'),
                              subtitle: Text('+1 437 955 5902'),
                            ),
                            ListTile(
                              leading: Icon(Icons.email, color: Colors.blue),
                              title: Text('Email'),
                              subtitle:
                              Text('farmdirectcustomercare@gmail.com'),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Contact Us'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Manage Produce',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_grocery_store),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 28, color: Colors.green),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
