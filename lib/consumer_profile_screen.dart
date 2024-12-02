import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'consumer_home_screen.dart';
import 'consumer_orders_screen.dart';
import 'login_screen.dart'; // Import HomeScreen for navigation
import 'edit_profile_screen.dart'; // Import the EditProfileScreen

class ConsumerProfileScreen extends StatefulWidget {
  @override
  _ConsumerProfileScreenState createState() => _ConsumerProfileScreenState();
}

class _ConsumerProfileScreenState extends State<ConsumerProfileScreen> {
  Map<String, String> consumerProfile = {
    'name': 'Loading...',
    'address': 'Loading...',
    'contact': 'Loading...',
    'email': 'Loading...',
  };

  // Fetch the profile data from Firestore
  void _fetchUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser; // Get the current user
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email) // Use the email as the document ID
            .get();

        if (userDoc.exists) {
          setState(() {
            consumerProfile = {
              'name': userDoc['name'] ?? 'N/A',
              'address': userDoc['address'] ?? 'N/A',
              'contact': userDoc['contact'] ?? 'N/A',
              'email': userDoc['email'] ?? 'N/A',
            };
          });
        } else {
          print('No user data found');
        }
      } catch (e) {
        print('Error fetching user profile: $e');
      }
    }
  }

  // Log out the user
  void _logout() async {
    await FirebaseAuth.instance.signOut(); // Log out from Firebase
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false, // This removes all previous routes
    );
  }

  // Navigate to the Edit Profile screen
  void _editProfile() async {
    final updatedProfile = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(profile: consumerProfile),
      ),
    );

    if (updatedProfile != null) {
      setState(() {
        consumerProfile = updatedProfile;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserProfile(); // Fetch the user profile when the screen is loaded
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
            _buildDetailRow(Icons.phone, 'Contact', consumerProfile['contact'] ?? 'N/A'),
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
              onPressed: _logout,
              icon: Icon(Icons.logout),
              label: Text('Log Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[300],
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ConsumerOrdersScreen()),
            );
          }
        },
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