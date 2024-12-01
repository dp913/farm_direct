import 'package:flutter/material.dart';
import 'consumer_home_screen.dart';
import 'consumer_orders_screen.dart';
import 'login_screen.dart'; // Import HomeScreen for navigation
import 'edit_profile_screen.dart'; // Import the EditProfileScreen

class ConsumerProfileScreen extends StatefulWidget {
  @override
  _ConsumerProfileScreenState createState() => _ConsumerProfileScreenState();
}

class _ConsumerProfileScreenState extends State<ConsumerProfileScreen> {
  // Initial consumer profile data
  Map<String, String> consumerProfile = {
    'name': 'John Doe',
    'address': '123 Maple Street, Toronto',
    'contact': '+1 234 567 890',
    'email': 'johndoe@example.com',
  };

  // Phone and email data
  final String phoneNumber = '+1 437 955 5902';
  final String email = 'farmdirectcustomercare@gmail.com';

  // Navigate to EditProfileScreen
  void _editProfile() async {
    final updatedProfile = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(profile: consumerProfile),
      ),
    );

    // If the profile is updated, update the state
    if (updatedProfile != null) {
      setState(() {
        consumerProfile = updatedProfile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
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
                backgroundImage: AssetImage('assets/profile_placeholder.png'),
              ),
            ),
            const SizedBox(height: 16),

            // User Information
            Center(
              child: Column(
                children: [
                  Text(
                    consumerProfile['name'] ?? 'N/A',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    consumerProfile['email'] ?? 'N/A',
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
            _buildDetailRow(Icons.phone, 'Phone', consumerProfile['contact'] ?? 'N/A'),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.location_on, 'Address', consumerProfile['address'] ?? 'N/A'),
            const SizedBox(height: 16),

            // Action Buttons
            const Divider(),
            ElevatedButton.icon(
              onPressed: _editProfile,
              icon: Icon(Icons.edit),
              label: Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                // Logic for logging out
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false, // This removes all previous routes
                );
              },
              icon: Icon(Icons.logout),
              label: Text('Log Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[300],
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Contact Us Button
            ElevatedButton(
              onPressed: () {
                // Display contact details when button is clicked
                _showContactDetailsDialog();
              },
              child: Text('Contact Us'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 2, // Set current index to Profile
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          // Handle navigation based on the tapped item
          if (index == 0) {
            // Navigate to Home screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (index == 1) {
            // Navigate to Orders screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ConsumerOrdersScreen()),
            );
          } else if (index == 2) {
            // Already in Profile screen
          }
        },
      ),
    );
  }

  // Method to display contact details dialog
  // void _showContactDetailsDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Contact Us'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text('Phone: $phoneNumber'),
  //             SizedBox(height: 8),
  //             Text('Email: $email'),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context); // Close the dialog
  //             },
  //             child: Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  // Method to display contact details dialog
  void _showContactDetailsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Contact Us',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Ensures dialog isn't unnecessarily large
              children: [
                Row(
                  children: [
                    Icon(Icons.phone, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Phone: $phoneNumber',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16), // Add space between items
                Row(
                  children: [
                    Icon(Icons.email, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Email: $email',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
  }


  // Method to build the profile details row
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
