// lib/product_page.dart
import 'package:flutter/material.dart';
import 'farmer_list_screen.dart';
import 'consumer_home_screen.dart'; // Import for navigation to HomeScreen

class ProductCategoryScreen extends StatelessWidget {
  final String category;

  ProductCategoryScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    // Example list of products for demonstration
    final products = _getProductsByCategory(category);

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search Box
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search products',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  // Add search functionality here if needed
                },
              ),
            ),
            // Grid of Product Cards
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(product: product);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          // Handle navigation based on the tapped item
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (index == 1) {
            // Navigate to Orders screen
          } else if (index == 2) {
            // Navigate to Profile screen
          }
        },
      ),
    );
  }

  // Mock function to retrieve products by category
  List<Map<String, String>> _getProductsByCategory(String category) {
    if (category == 'Vegetables') {
      return [
        {'name': 'Tomato', 'image': 'assets/tomato.png'},
        {'name': 'Carrot', 'image': 'assets/carrot.png'},
        // Add more vegetables here
      ];
    } else if (category == 'Fruits') {
      return [
        {'name': 'Apple', 'image': 'assets/apple.png'},
        {'name': 'Banana', 'image': 'assets/banana.png'},
        // Add more fruits here
      ];
    }
    return [];
  }
}

class ProductCard extends StatelessWidget {
  final Map<String, String> product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FarmerListScreen(product: product['name'] ?? ''),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              product['image'] ?? '',
              height: 150,
              width: 150,
            ),
            SizedBox(height: 8),
            Text(
              product['name'] ?? '',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
