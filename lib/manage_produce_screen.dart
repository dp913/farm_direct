// lib/manage_produce_screen.dart
import 'package:flutter/material.dart';
import 'add_produce.dart';

class ManageProduceScreen extends StatefulWidget {
  @override
  _ManageProduceScreenState createState() => _ManageProduceScreenState();
}

class _ManageProduceScreenState extends State<ManageProduceScreen> {
  final List<Map<String, String>> _produceList = [
    {
      'name': 'Tomato',
      'quantity': '100 kg',
      'price': '\$2.5/kg',
      'image': 'assets/tomato.png',
    },
    {
      'name': 'Carrot',
      'quantity': '50 kg',
      'price': '\$1.8/kg',
      'image': 'assets/carrot.png',
    },
  ];

  // Function to handle editing a product
  void _editProduce(int index) async {
    final produce = _produceList[index];

    // Show a dialog to edit product details
    final updatedProduce = await showDialog<Map<String, String>>(
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
                Navigator.pop(context, {
                  'name': nameController.text,
                  'quantity': quantityController.text,
                  'price': priceController.text,
                  'image': produce['image'] ?? '',
                });
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (updatedProduce != null) {
      setState(() {
        _produceList[index] = updatedProduce; // Update the product details
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Produce'),
      ),
      body: ListView.builder(
        itemCount: _produceList.length,
        itemBuilder: (context, index) {
          final produce = _produceList[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.asset(
                produce['image'] ?? '',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(produce['name'] ?? ''),
              subtitle: Text('${produce['quantity']} - ${produce['price']}'),
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
            setState(() {
              _produceList.add(newProduce); // Add new product
            });
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Add Produce',
      ),
    );
  }
}
