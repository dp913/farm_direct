import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'edit_profile_screen.dart';
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

  bool isLoading = true; // For displaying the loading state

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  // Function to fetch farmer's profile from Firestore
  Future<void> _fetchProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .get();

        if (snapshot.exists) {
          setState(() {
            farmerProfile = {
              'name': snapshot['name'] ?? 'N/A',
              'address': snapshot['address'] ?? 'N/A',
              'contact': snapshot['contact'] ?? 'N/A',
              'email': snapshot['email'] ?? 'N/A',
            };
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching profile: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

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

  // Function to handle profile edit navigation
  void _editProfile() async {
    final updatedProfile = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(profile: farmerProfile),
      ),
    );

    if (updatedProfile != null) {
      setState(() {
        farmerProfile = updatedProfile; // Update profile with new data
        _updateProfileInFirestore(updatedProfile); // Update Firestore as well
      });
    }
  }

  // Function to update the profile data in Firestore
  Future<void> _updateProfileInFirestore(Map<String, String> updatedProfile) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('farmers').doc(user.email).update({
          'name': updatedProfile['name'],
          'address': updatedProfile['address'],
          'contact': updatedProfile['contact'],
          'email': updatedProfile['email'],
        });
      }
    } catch (e) {
      print('Error updating profile in Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Management'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching
          : SingleChildScrollView(
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
            _buildDetailRow(Icons.phone, 'Contact', farmerProfile['contact'] ?? 'N/A'),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.location_on, 'Address', farmerProfile['address'] ?? 'N/A'),
            const SizedBox(height: 16),

            // Action Buttons
            const Divider(),
            Align(
              alignment: Alignment.centerLeft, // Align Edit Profile button to the left
              child: ElevatedButton.icon(
                onPressed: _editProfile, // Edit profile functionality
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
              alignment: Alignment.centerLeft, // Align Log Out button to the left
              child: ElevatedButton.icon(
                onPressed: () {
                  // Logic for logging out
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