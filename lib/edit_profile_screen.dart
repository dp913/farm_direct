import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, String> profile;

  EditProfileScreen({required this.profile});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController contactController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();

    // Initialize the controllers with the passed profile data
    nameController = TextEditingController(text: widget.profile['name']);
    addressController = TextEditingController(text: widget.profile['address']);
    contactController = TextEditingController(text: widget.profile['contact']);
    emailController = TextEditingController(text: widget.profile['email']);
  }

  @override
  void dispose() {
    // Dispose the controllers when the screen is disposed
    nameController.dispose();
    addressController.dispose();
    contactController.dispose();
    emailController.dispose();
    super.dispose();
  }

  // Function to save the updated profile in Firestore
  Future<void> _saveProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Update the Firestore document for the user
        await FirebaseFirestore.instance.collection('users').doc(user.email).update({
          'name': nameController.text,
          'address': addressController.text,
          'contact': contactController.text,
          'email': emailController.text,
        });

        // After updating the database, return the updated profile
        Navigator.pop(context, {
          'name': nameController.text,
          'address': addressController.text,
          'contact': contactController.text,
          'email': emailController.text,
        });
      } catch (e) {
        // Handle any errors that might occur during Firestore update
        print('Error updating profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update profile. Please try again later.'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contactController,
                decoration: InputDecoration(labelText: 'Contact'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProfile,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}