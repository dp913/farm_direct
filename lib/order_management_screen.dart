import 'package:flutter/material.dart';
import 'farmer_dashboard_screen.dart';
import 'manage_produce_screen.dart';
import 'profile_management_screen.dart';

class OrderManagementScreen extends StatefulWidget {
  @override
  _OrderManagementScreenState createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  final List<Map<String, String>> orderList = [
    {
      'orderId': 'ORD123',
      'product': 'Tomato',
      'quantity': '20 kg',
      'status': 'Pending',
      'buyer': 'Alex Johnson',
      'date': '2024-11-01',
      'price': '\$40',
      'image': 'assets/tomato.png',
    },
    {
      'orderId': 'ORD124',
      'product': 'Carrot',
      'quantity': '15 kg',
      'status': 'Completed',
      'buyer': 'Lisa Brown',
      'date': '2024-10-28',
      'price': '\$30',
      'image': 'assets/carrot.png',
    },
    {
      'orderId': 'ORD125',
      'product': 'Potato',
      'quantity': '25 kg',
      'status': 'In Progress',
      'buyer': 'John Doe',
      'date': '2024-11-02',
      'price': '\$50',
      'image': 'assets/carrot.png',
    },
  ];

  List<Map<String, String>> filteredOrders = [];
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
    filteredOrders = orderList; // Initialize the filtered list with all orders
  }

  void _onSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredOrders = orderList
          .where((order) =>
          order['buyer']!.toLowerCase().contains(searchQuery)) // Filter by buyer name
          .toList();
    });
  }

  void _filterOrders(String status) {
    setState(() {
      if (status == 'All') {
        filteredOrders = orderList;
      } else {
        filteredOrders = orderList
            .where((order) => order['status'] == status)
            .toList();
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
          // Search bar below the AppBar
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
          // Filter buttons with Show All button included
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: [

                ElevatedButton(
                  onPressed: () => _filterOrders('Pending'),
                  child: Text('Pending'),
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
          // Display filtered orders
          Expanded(
            child: filteredOrders.isEmpty
                ? Center(
              child: Text(
                'No orders found for "$searchQuery"',
                style: TextStyle(fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                return OrderCard(
                  order: order,
                  onStatusChanged: () {
                    setState(() {}); // Refresh the UI when order status changes
                  },
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

  void _updateOrderStatus(Map<String, String> order, String newStatus) {
    order['status'] = newStatus; // Update the status locally
    onStatusChanged(); // Notify parent widget to refresh the UI
  }
}
