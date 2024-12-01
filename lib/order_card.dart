import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final Map<String, String> order;
  final VoidCallback onStatusChanged; // Callback to notify status changes

  OrderCard({required this.order, required this.onStatusChanged});

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
            Text('Status: ${order['status'] ?? ''}'),
          ],
        ),
        trailing: Icon(
          order['status'] == 'Completed'
              ? Icons.check_circle
              : order['status'] == 'In Progress'
              ? Icons.sync
              : Icons.access_time,
          color: order['status'] == 'Completed'
              ? Colors.green
              : order['status'] == 'In Progress'
              ? Colors.blue
              : Colors.orange,
        ),
        onTap: () {
          _handleOrderTap(context, order);
        },
      ),
    );
  }

  void _handleOrderTap(BuildContext context, Map<String, String> order) {
    String currentStatus = order['status'] ?? 'Pending';

    if (currentStatus == 'Pending') {
      // Dialog for approving or rejecting a new order
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Order Action'),
            content: Text('Do you want to approve or reject this order?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _updateOrderStatus(order, 'In Progress');
                },
                child: Text('Approve'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _updateOrderStatus(order, 'Rejected');
                },
                child: Text('Reject'),
              ),
            ],
          );
        },
      );
    } else if (currentStatus == 'In Progress') {
      // Dialog to mark the order as completed
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Mark as Completed'),
            content: Text('Do you want to mark this order as completed?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _updateOrderStatus(order, 'Completed');
                },
                child: Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('No'),
              ),
            ],
          );
        },
      );
    } else if (currentStatus == 'Completed') {
      // Show a simple message for completed orders
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('This order is already completed.'),
        ),
      );
    }
  }

  void _updateOrderStatus(Map<String, String> order, String newStatus) {
    order['status'] = newStatus; // Update the status locally
    onStatusChanged(); // Notify parent widget to refresh the UI
  }
}
