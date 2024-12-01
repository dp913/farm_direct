import 'package:flutter/material.dart';
import 'consumer_home_screen.dart';
import 'consumer_orders_screen.dart';
import 'consumer_place_order_screen.dart';
import 'consumer_profile_screen.dart'; // Import for navigation to ProfileScreen

class ProductDetailScreen extends StatelessWidget {
  final Map<String, String> farmerDetails;

  ProductDetailScreen({required this.farmerDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${farmerDetails['name']}\'s Produce'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            SizedBox(
              height: 200,
              child: Image.asset(
                farmerDetails['image'] ?? '',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 16),

            // Farmer's Product Details
            Text(
              'Produce Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Product: ${farmerDetails['product']}'),
            Text('Quantity: ${farmerDetails['quantity']} kg'),
            Text('Rate: ${farmerDetails['rate']}'),
            Text('Posted on: ${farmerDetails['datePosted']}'),
            const SizedBox(height: 16),

            // Farmer's Contact Information
            Text(
              'Farmer Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Name: ${farmerDetails['name']}'),
            Text('Location: ${farmerDetails['location']}'),
            Text('Contact: ${farmerDetails['contact']}'),
            const SizedBox(height: 16),

            // Delivery Information
            Text(
              'Delivery Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Delivery Available: ${farmerDetails['delivery']}'),
            const SizedBox(height: 32),

            // Request Order Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlaceOrderScreen(farmerDetails: farmerDetails),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Button color
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text(
                  'Request Order',
                  style: TextStyle(
                    color: Colors.white, // Text color set to white
                    fontSize: 18,        // Adjust font size if necessary
                  ),
                ),
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
            // Navigate to Orders screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ConsumerOrdersScreen()),
            );
          } else if (index == 2) {
            // Navigate to Profile screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ConsumerProfileScreen()),
            );
          }
        },
      ),
    );
  }

  // Show confirmation dialog
  void _showOrderConfirmation(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Request Order'),
            content: Text('Are you sure you want to request this order?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  // Optionally navigate to an order confirmation screen or show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Order request sent successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: Text('Confirm'),
              ),
            ],
          );
          },
        );
    }
}
