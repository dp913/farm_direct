// lib/add_produce.dart
import 'package:flutter/material.dart';

class AddDetailsScreen extends StatefulWidget {
  @override
  _AddDetailsScreenState createState() => _AddDetailsScreenState();
}

class _AddDetailsScreenState extends State<AddDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers to manage form input
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _datePostedController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  String _deliveryAvailable = 'Yes'; // Default value for delivery availability

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                TextFormField(
                  controller: _productNameController,
                  decoration: InputDecoration(labelText: 'Product Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Quantity
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(labelText: 'Quantity (in kg)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the quantity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Rate
                TextFormField(
                  controller: _rateController,
                  decoration: InputDecoration(labelText: 'Rate (e.g. \$2.5/kg)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the rate';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Date Posted
                TextFormField(
                  controller: _datePostedController,
                  decoration: InputDecoration(labelText: 'Date Posted'),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      _datePostedController.text =
                      "${date.year}-${date.month}-${date.day}";
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Location
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Contact
                TextFormField(
                  controller: _contactController,
                  decoration: InputDecoration(labelText: 'Contact'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the contact information';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Delivery Availability
                Row(
                  children: [
                    Text(
                      'Delivery Available: ',
                      style: TextStyle(fontSize: 16),
                    ),
                    DropdownButton<String>(
                      value: _deliveryAvailable,
                      items: ['Yes', 'No']
                          .map((value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _deliveryAvailable = value ?? 'Yes';
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Handle form submission
                        final newProduce = {
                          'product': _productNameController.text,
                          'quantity': _quantityController.text,
                          'rate': _rateController.text,
                          'datePosted': _datePostedController.text,
                          'location': _locationController.text,
                          'contact': _contactController.text,
                          'delivery': _deliveryAvailable,
                        };

                        Navigator.pop(context, newProduce);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding:
                      EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text('Add'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
