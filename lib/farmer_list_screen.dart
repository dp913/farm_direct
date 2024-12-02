import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'consumer_orders_screen.dart';
import 'consumer_profile_screen.dart';
import 'product_detail_screen.dart';
import 'consumer_home_screen.dart';

class FarmerListScreen extends StatefulWidget {
  final String product;

  FarmerListScreen({required this.product});

  @override
  _FarmerListScreenState createState() => _FarmerListScreenState();
}

class _FarmerListScreenState extends State<FarmerListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> allFarmers = [];
  List<Map<String, dynamic>> displayedFarmers = [];
  String searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFarmersForProduct(widget.product);
  }

  // Fetch farmers' produce from Firestore for the selected product
  Future<void> _fetchFarmersForProduct(String product) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('produces')
          .where('product', isEqualTo: product)
          .get();

      setState(() {
        allFarmers = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'produce_id': doc.id,
            'name': data['farmerName'] ?? 'Unknown Farmer',
            'location': data['location'] ?? 'Unknown Location',
            'rate': '\$${data['rate']}/kg',
            'product': data['product'],
            'quantity': data['quantity'],
            'datePosted': data['datePosted'],
            'contact': data['contact'],
            'delivery': (data['delivery'] is bool)
                ? (data['delivery'] ? 'Yes' : 'No')
                : (data['delivery'] == 'Yes' ? 'Yes' : 'No'),
          };
        }).toList();
        displayedFarmers = List.from(allFarmers);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching farmers for product: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Update displayed farmers based on search query
  void updateSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      displayedFarmers = allFarmers.where((farmer) {
        final name = (farmer['name'] ?? '').toLowerCase();
        final location = (farmer['location'] ?? '').toLowerCase();
        return name.contains(searchQuery) || location.contains(searchQuery);
      }).toList();
    });
  }

  // Apply filter function for sorting farmers
  void applyFilter(String filter) {
    setState(() {
      if (filter == 'Price (Low to High)') {
        displayedFarmers.sort((a, b) =>
            double.parse(a['rate']!.substring(1).split('/')[0])
                .compareTo(double.parse(b['rate']!.substring(1).split('/')[0])));
      } else if (filter == 'Price (High to Low)') {
        displayedFarmers.sort((a, b) =>
            double.parse(b['rate']!.substring(1).split('/')[0])
                .compareTo(double.parse(a['rate']!.substring(1).split('/')[0])));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.product} Farmers'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: updateSearch,
                    decoration: InputDecoration(
                      hintText: 'Search by name or location',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () => _showFilterOptions(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedFarmers.length,
              itemBuilder: (context, index) {
                final farmer = displayedFarmers[index];
                final farmerDetails = farmer.map((key, value) => MapEntry(
                    key, value.toString())); // Convert all values to String
                return FarmerCard(
                    name: farmer['name'] ?? '',
                    location: farmer['location'] ?? '',
                    rate: farmer['rate'] ?? '',
                    farmerDetails: farmerDetails,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: Colors.grey,
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ConsumerOrdersScreen()),
            );
          } else if (index == 2) {
            // Navigate to Profile screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ConsumerProfileScreen()),
            );
          }
        },
      ),
    );
  }

  // Display filter options
  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Price (Low to High)'),
              onTap: () {
                applyFilter('Price (Low to High)');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Price (High to Low)'),
              onTap: () {
                applyFilter('Price (High to Low)');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class FarmerCard extends StatelessWidget {
  final String name;
  final String location;
  final String rate;
  final Map<String, String> farmerDetails;

  FarmerCard({
    required this.name,
    required this.location,
    required this.rate,
    required this.farmerDetails,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductDetailScreen(farmerDetails: farmerDetails),
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: Image.asset(
            'assets/${farmerDetails['product']}.png',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/default.png', // Default image
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              );
            },
          ),
          title: Text(name),
          subtitle: Text(location),
          trailing: Text(rate),
        ),
      ),
    );
  }
}
