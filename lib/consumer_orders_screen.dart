import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'consumer_home_screen.dart';
import 'consumer_profile_screen.dart';

class ConsumerOrdersScreen extends StatefulWidget {
  @override
  _ConsumerOrdersScreenState createState() => _ConsumerOrdersScreenState();
}

class _ConsumerOrdersScreenState extends State<ConsumerOrdersScreen> {
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  // Fetch the orders from Firestore for the current logged-in user
  Future<void> _fetchOrders() async {
    try {
      // Get the current logged-in user
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        setState(() {
          _errorMessage = 'User not logged in';
          _isLoading = false;
        });
        return;
      }

      // Get the current user's email
      String userEmail = currentUser.email ?? '';

      // Fetch the consumer's name from the 'users' collection based on email
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (userSnapshot.docs.isEmpty) {
        setState(() {
          _errorMessage = 'User not found in the users collection';
          _isLoading = false;
        });
        return;
      }

      // Get the consumer's name from the user document
      String consumerName = userSnapshot.docs.first['name'] ?? 'Unknown User';

      // Fetch the orders of the logged-in user from Firestore based on consumerName
      QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('consumerName', isEqualTo: consumerName)
          .get();

      // Map the fetched documents to a list of orders
      List<Map<String, dynamic>> orders = ordersSnapshot.docs.map((doc) {
        return {
          'product': doc['product'] ?? 'Unknown Product',
          'farmer': doc['farmerName'] ?? 'Unknown Farmer',
          'quantity': '${doc['requestedQuantity']} kg',
          'price': '\$${doc['totalPrice'].toStringAsFixed(2)}',
          'status': doc['status'] ?? 'Unknown Status',

        };
      }).toList();

      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to load orders: $error';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          final order = _orders[index];
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
  final Map<String, dynamic> order;

  OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.asset(
          'assets/${order['product']}.png',
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
          order['status'] == 'Completed'
              ? Icons.check_circle
              : Icons.access_time,
          color: order['status'] == 'Completed' ? Colors.green : Colors.orange,
        ),
      ),
    );
  }
}
