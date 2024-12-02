import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'manage_produce_screen.dart';
import 'order_management_screen.dart';
import 'profile_management_screen.dart';

class FarmerDashboardScreen extends StatefulWidget {
  @override
  _FarmerDashboardScreenState createState() => _FarmerDashboardScreenState();
}

class _FarmerDashboardScreenState extends State<FarmerDashboardScreen> {
  int _selectedIndex = 0;
  int totalProduce = 0;
  int pendingOrders = 0;
  int completedSales = 0;
  double totalRevenue = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData(); // Fetch data from Firestore
  }

  // Fetch data from Firebase Firestore
  Future<void> _fetchDashboardData() async {
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

      String farmerName = userDoc.exists ? userDoc['name'] ?? 'Unknown User' : 'Unknown User';

      // Fetch total produce count
      var productsSnapshot = await FirebaseFirestore.instance.collection('produces').where('farmerName', isEqualTo: farmerName).get();
      setState(() {
        totalProduce = productsSnapshot.docs.length;
      });

      // Fetch pending orders count
      var pendingOrdersSnapshot = await FirebaseFirestore.instance
          .collection('orders').where('farmerName', isEqualTo: farmerName)
          .where('status', isEqualTo: 'In Progress')
          .get();
      setState(() {
        pendingOrders = pendingOrdersSnapshot.docs.length;
      });

      // Fetch completed sales count (or number of completed orders)
      var completedOrdersSnapshot = await FirebaseFirestore.instance
          .collection('orders').where('farmerName', isEqualTo: farmerName)
          .where('status', isEqualTo: 'Completed')
          .get();
      setState(() {
        completedSales = completedOrdersSnapshot.docs.length;
      });

      // Fetch total revenue (sum of completed order amounts)
      var revenueSnapshot = await FirebaseFirestore.instance
          .collection('orders').where('farmerName', isEqualTo: farmerName)
          .where('status', isEqualTo: 'Completed')
          .get();
      double total = 0.0;
      revenueSnapshot.docs.forEach((doc) {
        total += doc['totalPrice']; // Assuming totalPrice is a field in order document
      });
      setState(() {
        totalRevenue = total;
      });
    } catch (e) {
      print("Error fetching dashboard data: $e");
    }
  }

  final List<Widget> _screens = [
    FarmerDashboardScreen(), // Self-reference for navigation consistency
    ManageProduceScreen(),
    OrderManagementScreen(),
    ProfileManagementScreen(),
  ];

  final List<String> _titles = [
    'Farmer Dashboard',
    'Manage Produce',
    'Orders',
    'Profile',
  ];

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
        title: Text(_titles[_selectedIndex]),
      ),
      body: _selectedIndex == 0
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildDashboardCard(
                  context,
                  title: 'Total Produce',
                  value: '$totalProduce Items',
                  icon: Icons.local_florist,
                  color: Colors.green,
                  onTap: () {
                    // Navigate to Total Produce report
                  },
                ),
                _buildDashboardCard(
                  context,
                  title: 'Pending Orders',
                  value: '$pendingOrders Orders',
                  icon: Icons.pending_actions,
                  color: Colors.orange,
                  onTap: () {
                    // Navigate to Pending Orders report
                  },
                ),
                _buildDashboardCard(
                  context,
                  title: 'Completed Sales',
                  value: '$completedSales Orders',
                  icon: Icons.shopping_cart,
                  color: Colors.blue,
                  onTap: () {
                    // Navigate to Completed Sales report
                  },
                ),
                _buildDashboardCard(
                  context,
                  title: 'Total Revenue',
                  value: '\$${totalRevenue.toStringAsFixed(2)}',
                  icon: Icons.attach_money,
                  color: Colors.teal,
                  onTap: () {
                    // Navigate to Total Revenue report
                  },
                ),
              ],
            ),
          ),
        ],
      )
          : _screens[_selectedIndex],
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
        showUnselectedLabels: true, // Display labels for unselected items
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildDashboardCard(
      BuildContext context, {
        required String title,
        required String value,
        required IconData icon,
        required Color color,
        required Function() onTap,
      }) {
    return Card(
      color: color.withOpacity(0.2),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              SizedBox(height: 10),
              Text(
                value,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
