import 'package:flutter/material.dart';

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
          ],
        ),
      ),
    );
  }
}