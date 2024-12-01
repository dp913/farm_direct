// lib/order_management_screen.dart
import 'package:flutter/material.dart';

class OrderManagementScreen extends StatelessWidget {
  final List<Map<String, String>> orderList = [
    {
      'orderId': 'ORD123',
      'product': 'Tomato',
      'quantity': '20 kg',
      'status': 'Pending',
      'buyer': 'Alex Johnson',
      'date': '2024-11-01',
      'price': '\$40', // Added price
      'image': 'assets/tomato.png', // Added image path
    },
    {
      'orderId': 'ORD124',
      'product': 'Carrot',
      'quantity': '15 kg',
      'status': 'Completed',
      'buyer': 'Lisa Brown',
      'date': '2024-10-28',
      'price': '\$30', // Added price
      'image': 'assets/carrot.png', // Added image path
    },
    // Add more orders as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Management'),
      ),
      body: ListView.builder(
        itemCount: orderList.length,
        itemBuilder: (context, index) {
          final order = orderList[index];
          return OrderCard(order: order);
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, String> order;

  OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.asset(
          order['image'] ?? 'assets/placeholder.png', // Default image
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(order['product'] ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Buyer: ${order['buyer'] ?? ''}'),
            Text('Quantity: ${order['quantity'] ?? ''}'),
            Text('Price: ${order['price'] ?? ''}'),
            Text('Date: ${order['date'] ?? ''}'),
          ],
        ),
        trailing: Icon(
          order['status'] == 'Completed'
              ? Icons.check_circle
              : Icons.access_time,
          color: order['status'] == 'Completed' ? Colors.green : Colors.orange,
        ),
        onTap: () {
          // Logic to view order details or update status
        },
      ),
    );
  }
}
