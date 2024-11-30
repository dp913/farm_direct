import 'package:flutter/material.dart';

import 'consumer_home_screen.dart';
import 'consumer_profile_screen.dart';

class ConsumerOrdersScreen extends StatelessWidget {
  // Mock list of orders
  final List<Map<String, String>> orders = [
    {
      'product': 'Tomato',
      'farmer': 'John Doe',
      'quantity': '10 kg',
      'price': '\$25',
      'status': 'Requested',
      'image': 'assets/tomato.png',
    },
    {
      'product': 'Carrot',
      'farmer': 'Alice Smith',
      'quantity': '5 kg',
      'price': '\$15',
      'status': 'In Progress',
      'image': 'assets/carrot.png',
    },
    {
      'product': 'Apple',
      'farmer': 'Bob Johnson',
      'quantity': '8 kg',
      'price': '\$20',
      'status': 'Delivered',
      'image': 'assets/apple.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return OrderCard(order: order);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Set this to 1 because this is the Orders page
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: Colors.green, // Highlighted color
        unselectedItemColor: Colors.grey, // Non-highlighted color
        showUnselectedLabels: true,
        onTap: (index) {
          // Navigation logic
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (index == 1) {
            // Stay on Orders screen
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ConsumerProfileScreen()),
            );
          }
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
          order['image']!,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(order['product']!),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Farmer: ${order['farmer']}'),
            Text('Quantity: ${order['quantity']}'),
            Text('Price: ${order['price']}'),
            Text('Status: ${order['status']}'),
          ],
        ),
        trailing: Icon(
          order['status'] == 'Delivered'
              ? Icons.check_circle
              : Icons.access_time,
          color: order['status'] == 'Delivered' ? Colors.green : Colors.orange,
        ),
      ),
    );
  }
}
