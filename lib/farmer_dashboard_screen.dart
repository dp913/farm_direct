// lib/farmer_dashboard_screen.dart
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

  // List of widgets to be shown when each tab is selected
  final List<Widget> _screens = [
    Center(child: Text('Dashboard Overview')), // Placeholder for Dashboard overview
    ManageProduceScreen(),
    OrderManagementScreen(),
    ProfileManagementScreen(),
  ];

  // Titles for the AppBar based on the selected index
  final List<String?> _titles = [
    'Farmer Dashboard', // Title for Dashboard screen
    'Manage Produce', // No title for Manage Produce
    null, // No title for Order Management
    null, // No title for Profile Management
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex] ?? ''), // Set title based on selected tab
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
                  value: '15 Items',
                  icon: Icons.local_florist,
                  color: Colors.green,
                  onTap: () {
                    // Navigate to Total Produce report
                  },
                ),
                _buildDashboardCard(
                  context,
                  title: 'Pending Orders',
                  value: '5 Orders',
                  icon: Icons.pending_actions,
                  color: Colors.orange,
                  onTap: () {
                    // Navigate to Pending Orders report
                  },
                ),
                _buildDashboardCard(
                  context,
                  title: 'Completed Sales',
                  value: '120',
                  icon: Icons.shopping_cart,
                  color: Colors.blue,
                  onTap: () {
                    // Navigate to Completed Sales report
                  },
                ),
                _buildDashboardCard(
                  context,
                  title: 'Total Revenue',
                  value: '\$3,500',
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
        unselectedItemColor: Colors.grey, // Improve contrast for unselected items
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
