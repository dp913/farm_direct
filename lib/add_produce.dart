// lib/add_produce.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import
import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuth import
import 'package:intl/intl.dart';


class AddDetailsScreen extends StatefulWidget {
  @override
  _AddDetailsScreenState createState() => _AddDetailsScreenState();
}

class _AddDetailsScreenState extends State<AddDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers to manage form input
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String _deliveryAvailable = 'Yes'; // Default value for delivery availability
  String _farmerName = ''; // Farmer's name (from logged-in user)
  String _contact = ''; // Farmer's contact (from logged-in user)
  String _datePosted = ''; // Date Posted (from system)

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _getUserDetails(); // Get user details on screen load
    _datePosted = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Get the current date for "Date Posted"
  }

  Future<void> _getUserDetails() async {
    // Get the logged-in user details
    User? user = _auth.currentUser;

    if (user != null) {
      // Fetch the user's details (e.g., Name and Contact)
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.email).get();
      if (userDoc.exists) {
        setState(() {
          _farmerName = userDoc['name'] ?? 'Unknown';
          _contact = userDoc['contact'] ?? 'Unknown';
        });
      }
    }
  }

  Future<void> _addProduce() async {
    if (_formKey.currentState!.validate()) {
      // Create a new produce object
      final newProduce = {
        'product': _productNameController.text,
        'quantity': _quantityController.text,
        'rate': _rateController.text,
        'datePosted': _datePosted, // System-generated Date
        'location': _locationController.text,
        'contact': _contact, // Logged-in user contact
        'farmerName': _farmerName, // Logged-in user name
        'delivery': _deliveryAvailable,
      };

      try {
        // Save the new produce to Firestore
        await _firestore.collection('produces').add(newProduce);
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Produce added successfully!')));
        // Go back to the previous screen
        Navigator.pop(context);
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add produce: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                TextFormField(
                  controller: _productNameController,
                  decoration: InputDecoration(labelText: 'Product Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Quantity
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(labelText: 'Quantity (in kg)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the quantity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Rate
                TextFormField(
                  controller: _rateController,
                  decoration: InputDecoration(labelText: 'Rate (e.g. \$2.5/kg)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the rate';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Location
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Delivery Availability
                Row(
                  children: [
                    Text(
                      'Delivery Available: ',
                      style: TextStyle(fontSize: 16),
                    ),
                    DropdownButton<String>(
                      value: _deliveryAvailable,
                      items: ['Yes', 'No']
                          .map((value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _deliveryAvailable = value ?? 'Yes';
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: _addProduce, // Call the Firestore add function
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding:
                      EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text('Add'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
