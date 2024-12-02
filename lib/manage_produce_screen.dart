// lib/manage_produce_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import
import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuth import
import 'farmer_dashboard_screen.dart';
import 'order_management_screen.dart';
import 'profile_management_screen.dart';
import 'add_produce.dart';

class ManageProduceScreen extends StatefulWidget {
  @override
  _ManageProduceScreenState createState() => _ManageProduceScreenState();
}

class _ManageProduceScreenState extends State<ManageProduceScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _produceList = [];
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _fetchFarmerProduce();
  }

  // Fetch farmer's produce from Firestore based on farmer's name
  Future<void> _fetchFarmerProduce() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.email).get();

      if (userDoc != null) {
        String farmerName = userDoc['name'] ?? 'Unknown'; // Get farmer's name from logged-in user

        try {
          QuerySnapshot snapshot = await _firestore
              .collection('produces')
              .where('farmerName', isEqualTo: farmerName)
              .get();

          setState(() {
            _produceList = snapshot.docs
                .map((doc) => {
              'id': doc.id,
              'name': doc['product'],
              'quantity': doc['quantity'],
              'price': doc['rate'],
            })
                .toList();
          });
        } catch (e) {
          print('Error fetching produce: $e');
        }
      }
    }
  }

  // Edit produce and update in Firestore
  void _editProduce(int index) async {
    final produce = _produceList[index];

    final updatedProduce = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController nameController =
        TextEditingController(text: produce['name']);
        final TextEditingController quantityController =
        TextEditingController(text: produce['quantity']);
        final TextEditingController priceController =
        TextEditingController(text: produce['price']);

        return AlertDialog(
          title: Text('Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Quantity (e.g., 50 kg)'),
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price (e.g., \$2.5/kg)'),
                keyboardType: TextInputType.text,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Dismiss without changes
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  {
                    'id': produce['id'],
                    'name': nameController.text,
                    'quantity': quantityController.text,
                    'price': priceController.text,
                  },
                );
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (updatedProduce != null) {
      // Update the produce in Firestore
      await _firestore
          .collection('produces')
          .doc(updatedProduce['id'])
          .update({
        'product': updatedProduce['name'],
        'quantity': updatedProduce['quantity'],
        'rate': updatedProduce['price'],
      });

      setState(() {
        // Update the product in the list
        _produceList[index] = updatedProduce;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Produce'),
      ),
      body: _produceList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _produceList.length,
        itemBuilder: (context, index) {
          final produce = _produceList[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.asset(
                'assets/${produce['name']}.png',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(produce['name'] ?? ''),
              subtitle: Text('${produce['quantity']} Kg - \$${produce['price']} /Kg'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _editProduce(index); // Call the edit function
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to AddDetailsScreen and wait for result
          final newProduce = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDetailsScreen()),
          );

          if (newProduce != null) {
            // Add the new produce to Firestore
            await _firestore.collection('produces').add({
              'product': newProduce['name'],
              'quantity': newProduce['quantity'],
              'rate': newProduce['price'],
              'farmerName': _auth.currentUser?.displayName ?? 'Unknown',
            });

            setState(() {
              _produceList.add(newProduce); // Add new product to the list
            });
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Add Produce',
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
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

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => _screens[index]),
      );
    }
  }

  final List<Widget> _screens = [
    FarmerDashboardScreen(),
    ManageProduceScreen(), // Self-reference for navigation consistency
    OrderManagementScreen(),
    ProfileManagementScreen(),
  ];
}
