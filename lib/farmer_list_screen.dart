// lib/farmer_list_screen.dart
import 'package:farm_direct/product_detail_screen.dart';
import 'package:flutter/material.dart';

class FarmerListScreen extends StatefulWidget {
  final String product;

  FarmerListScreen({required this.product});

  @override
  _FarmerListScreenState createState() => _FarmerListScreenState();
}

class _FarmerListScreenState extends State<FarmerListScreen> {
  List<Map<String, String>> allFarmers = [];
  List<Map<String, String>> displayedFarmers = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Retrieve farmers data based on selected product
    allFarmers = _getFarmersForProduct(widget.product);
    displayedFarmers = List.from(allFarmers);
  }

  // Update displayed farmers based on search query
  void updateSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      displayedFarmers = allFarmers.where((farmer) {
        final name = farmer['name']?.toLowerCase() ?? '';
        final location = farmer['location']?.toLowerCase() ?? '';
        return name.contains(searchQuery) || location.contains(searchQuery);
      }).toList();
    });
  }

  // Apply filter function for sorting farmers
  void applyFilter(String filter) {
    setState(() {
      if (filter == 'Price (Low to High)') {
        displayedFarmers.sort((a, b) => a['rate']!.compareTo(b['rate']!));
      } else if (filter == 'Price (High to Low)') {
        displayedFarmers.sort((a, b) => b['rate']!.compareTo(a['rate']!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.product} Farmers'),
      ),
      body: Column(
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
                return FarmerCard(
                  imageUrl: farmer['image'] ?? '',
                  name: farmer['name'] ?? '',
                  location: farmer['location'] ?? '',
                  rate: farmer['rate'] ?? '',
                  farmerDetails: farmer,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Mock function to retrieve farmers by product
  List<Map<String, String>> _getFarmersForProduct(String product) {
    return [
      {
        'image': 'assets/tomato_farmer.png',
        'name': 'John Doe',
        'location': 'Green Valley',
        'rate': '\$2.5/kg',
        'product': 'Tomato',
        'quantity': '500',
        'datePosted': '2024-10-01',
        'contact': '+1 234 567 890',
        'delivery': 'Yes'
      },
      {
        'image': 'assets/tomato_farmer2.png',
        'name': 'Alice Smith',
        'location': 'Sunset Farms',
        'rate': '\$2.8/kg',
        'product': 'Tomato',
        'quantity': '600',
        'datePosted': '2024-10-02',
        'contact': '+1 987 654 321',
        'delivery': 'No'
      },
      // Add more farmers as needed
    ];
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
            // Add more filter options here if needed
          ],
        );
      },
    );
  }
}

class FarmerCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String location;
  final String rate;
  final Map<String, String> farmerDetails; // Farmer's full details

  FarmerCard({
    required this.imageUrl,
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
            builder: (context) => ProductDetailScreen(farmerDetails: farmerDetails),
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: Image.asset(imageUrl, width: 50, height: 50, fit: BoxFit.cover),
          title: Text(name),
          subtitle: Text(location),
          trailing: Text(rate),
        ),
      ),
    );
  }
}
