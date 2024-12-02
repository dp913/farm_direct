import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PlaceOrderScreen extends StatefulWidget {
  final Map<String, dynamic> farmerDetails;

  PlaceOrderScreen({required this.farmerDetails});

  @override
  _PlaceOrderScreenState createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final _quantityController = TextEditingController();
  final _deliveryLocationController = TextEditingController();
  String? _orderSummary;
  String _quantity = '';

  void _generateOrderSummary() {
    setState(() {
      _quantity = _quantityController.text;

      if (_quantity.isNotEmpty && double.tryParse(_quantity) != null) {
        // Extract numeric part of the rate (e.g., "$1.5/kg" -> "1.5")
        String rawRate = widget.farmerDetails['rate'] ?? '0';
        String sanitizedRate = rawRate.replaceAll(RegExp(r'[^\d.]'), ''); // Keep only numbers and dot
        double rate = double.tryParse(sanitizedRate) ?? 0;

        // Retrieve available quantity from farmer details (assuming it's stored in 'quantity')
        double availableQuantity = double.tryParse(widget.farmerDetails['quantity'] ?? '0') ?? 0;

        // Check if entered quantity exceeds available quantity
        double enteredQuantity = double.parse(_quantity);
        if (enteredQuantity > availableQuantity) {
          _orderSummary = 'Entered quantity exceeds available stock. Available: ${availableQuantity.toStringAsFixed(2)} kg';
        } else {
          double totalPrice = rate * enteredQuantity;
          _orderSummary =
          'Product: ${widget.farmerDetails['product']}\nQuantity: $_quantity kg\nRate: \$${rate.toStringAsFixed(2)}/kg\nTotal: \$${totalPrice.toStringAsFixed(2)}';
        }
      } else {
        _orderSummary = 'Please enter a valid quantity';
      }
    });
  }

  Future<void> _placeOrder() async {
    String deliveryLocation = _deliveryLocationController.text;

    if (deliveryLocation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please provide a delivery location'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Extract numeric part of the rate (e.g., "$1.5/kg" -> "1.5")
      String rawRate = widget.farmerDetails['rate'] ?? '0';
      String sanitizedRate = rawRate.replaceAll(RegExp(r'[^\d.]'), ''); // Keep only numbers and dot
      double rate = double.tryParse(sanitizedRate) ?? 0;

      // Retrieve available quantity from farmer details
      double availableQuantity = double.tryParse(widget.farmerDetails['quantity'] ?? '0') ?? 0;
      double requestedQuantity = double.parse(_quantity);

      // Check if entered quantity exceeds available quantity
      if (requestedQuantity > availableQuantity) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Entered quantity exceeds available stock. Available: ${availableQuantity.toStringAsFixed(2)} kg'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      double totalPrice = rate * requestedQuantity;

      // Get the consumer's name from Firebase Authentication
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User not logged in'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Get current user's email
      String userEmail = currentUser.email ?? 'Unknown Email';

      // Fetch the user's name from the 'users' collection based on email
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail) // Assuming the email is used as the document ID
          .get();

      String consumerName = 'Unknown User';  // Default value if name not found

      // If the user document exists, get the name from it
      if (userDoc.exists) {
        consumerName = userDoc['name'] ?? 'Unknown User';
      }

      // Get the current date (without time) using DateFormat
      String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Add order to Firestore
      await FirebaseFirestore.instance.collection('orders').add({
        'product': widget.farmerDetails['product'] ?? 'Unknown Product',
        'farmerName': widget.farmerDetails['name'] ?? 'Unknown Farmer',
        'consumerName': consumerName, // Use the actual consumer name
        'requestedQuantity': requestedQuantity,
        'totalPrice': totalPrice,
        'date': formattedDate,
        'deliveryLocation': deliveryLocation,
        'status': 'Requested',
      });

      // Update the product quantity in Firestore
      double updatedQuantity = availableQuantity - requestedQuantity;

      // Update the document in the 'produces' collection
      await FirebaseFirestore.instance.collection('produces').doc(widget.farmerDetails['produce_id']).update({
        'quantity': updatedQuantity.toStringAsFixed(2),
      });

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Order Placed'),
            content: Text('Your order has been placed successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context); // Return to previous screen
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place Order'),
      ),
      body: SingleChildScrollView( // Wrap the entire body with SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Quantity to Request',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter quantity (kg)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                _generateOrderSummary();
              },
            ),
            SizedBox(height: 10),
            if (_orderSummary != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Summary:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(_orderSummary ?? ''),
                  SizedBox(height: 16),
                ],
              ),
            Text(
              'Delivery Location',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _deliveryLocationController,
              decoration: InputDecoration(
                hintText: 'Enter delivery location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 20), // Extra space to avoid overflow
            ElevatedButton(
              onPressed: _orderSummary != null && _quantity.isNotEmpty
                  ? _placeOrder
                  : null,
              child: Text(
                'Place Order',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
