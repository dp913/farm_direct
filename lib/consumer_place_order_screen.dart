// lib/place_order_screen.dart
import 'package:flutter/material.dart';

class PlaceOrderScreen extends StatefulWidget {
  final Map<String, String> farmerDetails;

  PlaceOrderScreen({required this.farmerDetails});

  @override
  _PlaceOrderScreenState createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final _quantityController = TextEditingController();
  String? _orderSummary;
  String _quantity = '';

  // Method to update order summary based on quantity entered
  void _generateOrderSummary() {
    setState(() {
      _quantity = _quantityController.text;
      if (_quantity.isNotEmpty && double.tryParse(_quantity) != null) {
        double rate = double.tryParse(widget.farmerDetails['rate'] ?? '0') ?? 0;
        double totalPrice = rate * double.parse(_quantity);
        _orderSummary =
        'Product: ${widget.farmerDetails['product']}\nQuantity: $_quantity kg\nRate: \$${rate.toStringAsFixed(2)}/kg\nTotal: \$${totalPrice.toStringAsFixed(2)}';
      } else {
        _orderSummary = 'Please enter a valid quantity';
      }
    });
  }

  // Method to place the order (simplified for demonstration)
  void _placeOrder() {
    // You can add your backend order logic here
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
                Navigator.pop(context); // Go back to Product Detail screen
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place Order'),
      ),
      body: Padding(
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
            SizedBox(height: 16),
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
            Spacer(),
            ElevatedButton(
              onPressed: _orderSummary != null && _quantity.isNotEmpty
                  ? _placeOrder
                  : null,
              child: Text(
                'Place Order',
                style: TextStyle(color: Colors.white), // Ensures the text color is white
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
