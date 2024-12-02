import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'farmer_dashboard_screen.dart';
import 'manage_produce_screen.dart';
import 'profile_management_screen.dart';

class OrderManagementScreen extends StatefulWidget {
  @override
  _OrderManagementScreenState createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  List<Map<String, dynamic>> orderList = [];
  List<Map<String, dynamic>> filteredOrders = [];
  String searchQuery = "";
  int _selectedIndex = 2;

  final List<Widget> _screens = [
    FarmerDashboardScreen(),
    ManageProduceScreen(),
    OrderManagementScreen(),
    ProfileManagementScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _fetchOrders(); // Fetch orders when the screen loads
  }

  Future<void> _fetchOrders() async {
    try {
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

      String userEmail = currentUser.email ?? 'Unknown Email';
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .get();

      String farmerName =
          userDoc.exists ? userDoc['name'] ?? 'Unknown User' : 'Unknown User';

      QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('farmerName', isEqualTo: farmerName)
          .get();

      List<Map<String, dynamic>> fetchedOrders = [];
      for (var doc in ordersSnapshot.docs) {
        fetchedOrders.add({
          'orderId': doc.id,
          'product': doc['product'],
          'quantity': doc['requestedQuantity'],
          'status': doc['status'],
          'buyer': doc['consumerName'],
          'date': doc['date'],
          'price': doc['totalPrice'],
        });
      }

      setState(() {
        orderList = fetchedOrders;
        filteredOrders = fetchedOrders; // Display all orders by default
      });
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }

  void _onSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredOrders = orderList
          .where((order) => order['buyer']!.toLowerCase().contains(searchQuery))
          .toList();
    });
  }

  void _filterOrders(String status) {
    setState(() {
      if (status == 'All') {
        filteredOrders = orderList;
      } else {
        filteredOrders =
            orderList.where((order) => order['status'] == status).toList();
      }
    });
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => _screens[index]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Management'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Search by buyer name...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: [
                ElevatedButton(
                  onPressed: () => _filterOrders('Requested'),
                  child: Text('Requested'),
                ),
                ElevatedButton(
                  onPressed: () => _filterOrders('In Progress'),
                  child: Text('In Progress'),
                ),
                ElevatedButton(
                  onPressed: () => _filterOrders('Completed'),
                  child: Text('Completed'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () => _filterOrders('All'),
                      child: Text('Show All'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredOrders.isEmpty
                ? Center(
                    child: Text(
                      searchQuery.isEmpty
                          ? 'No orders available.'
                          : 'No orders found for "$searchQuery"',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      final orderAsStringMap = order.map((key, value) => MapEntry(key, value.toString()));
                      return OrderCard(
                        order: orderAsStringMap,
                        onStatusChanged: () {
                          setState(
                              () {}); // Refresh the UI when order status changes
                        },
                        context: context, // Pass context
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Manage Produce',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_grocery_store),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, String> order;
  final VoidCallback onStatusChanged;
  final BuildContext context; // Add context parameter

  OrderCard({
    required this.order,
    required this.onStatusChanged,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.asset(
          'assets/${order['product']}.png', // Default image
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
          _handleOrderTap(context, order); // Pass context to the method
        },
      ),
    );
  }

  void _handleOrderTap(BuildContext context, Map<String, String> order) {
    String currentStatus = order['status'] ?? 'Requested';

    if (currentStatus == 'Requested') {
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
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, // Text color
                  backgroundColor: Colors.green, // Button color
                ),
                child: Text('Approve'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _updateOrderStatus(order, 'Rejected');
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, // Text color
                  backgroundColor: Colors.red, // Button color
                ),
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
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, // Text color
                  backgroundColor: Colors.green, // Button color
                ),
                child: Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, // Text color
                  backgroundColor: Colors.red, // Button color
                ),
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

  void _updateOrderStatus(Map<String, String> order, String newStatus) async {
    // Update the status locally
    order['status'] = newStatus;

    // Update the status in Firestore
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(order['orderId']) // Assuming orderId is the document ID
          .update({'status': newStatus});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order status updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update order status: $e')),
      );
    }

    // Notify parent widget to refresh the UI
    onStatusChanged();
  }
}

