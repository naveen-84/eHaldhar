import 'package:flutter/material.dart';

class AddProductPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onProductAdded;

  AddProductPage({required this.onProductAdded});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  double _price = 0.0;
  String _category = "";
  double _buyerBid = 0.0;

  void _submitProduct() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create a new product
      Map<String, dynamic> newProduct = {
        "name": _name,
        "price": _price,
        "category": _category,
        "buyerBid": _buyerBid,
      };

      // Send the product back to home page
      widget.onProductAdded(newProduct);

      // Navigate back to home
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Product")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Product Name"),
                validator: (value) =>
                    value!.isEmpty ? "Enter product name" : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter price" : null,
                onSaved: (value) => _price = double.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Category"),
                validator: (value) => value!.isEmpty ? "Enter category" : null,
                onSaved: (value) => _category = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Buyer's Bid"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "Enter buyer's bid" : null,
                onSaved: (value) => _buyerBid = double.parse(value!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitProduct,
                child: Text("Add Product"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
