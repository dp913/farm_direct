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
    },
    {
      'orderId': 'ORD124',
      'product': 'Carrot',
      'quantity': '15 kg',
      'status': 'Completed',
      'buyer': 'Lisa Brown',
      'date': '2024-10-28',
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
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('${order['product']} (${order['quantity']})'),
              subtitle: Text('Buyer: ${order['buyer']}\nDate: ${order['date']}'),
              trailing: Text(order['status'] ?? '', style: TextStyle(color: _getStatusColor(order['status']))),
              onTap: () {
                // Logic to view order details or update status
              },
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == 'Pending') return Colors.orange;
    if (status == 'Completed') return Colors.green;
    return Colors.grey;
  }
}
