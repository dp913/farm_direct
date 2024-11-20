// lib/manage_produce_screen.dart
import 'package:flutter/material.dart';

class ManageProduceScreen extends StatelessWidget {
  final List<Map<String, String>> produceList = [
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
    // Add more items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Produce'),
      ),
      body: ListView.builder(
        itemCount: produceList.length,
        itemBuilder: (context, index) {
          final produce = produceList[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.asset(produce['image'] ?? '', width: 50, height: 50, fit: BoxFit.cover),
              title: Text(produce['name'] ?? ''),
              subtitle: Text('${produce['quantity']} - ${produce['price']}'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Logic to edit produce
                },
              ),
              onTap: () {
                // Logic to view produce details
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logic to add new produce
        },
        child: Icon(Icons.add),
        tooltip: 'Add Produce',
      ),
    );
  }
}
