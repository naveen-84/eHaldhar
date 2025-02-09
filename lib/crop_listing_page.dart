import 'package:flutter/material.dart';
import 'dart:io';

class CropListingPage extends StatefulWidget {
  final String name;
  final String cropName;
  final String quantity;
  final String price;
  final String imagePath;

  CropListingPage({
    required this.name,
    required this.cropName,
    required this.quantity,
    required this.price,
    required this.imagePath,
  });

  @override
  _CropListingPageState createState() => _CropListingPageState();
}

class _CropListingPageState extends State<CropListingPage> {
  List<String> bidHistory = [];

  void placeBid(String bidAmount) {
    setState(() {
      bidHistory.add("Bid ₹$bidAmount by Buyer ${bidHistory.length + 1}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crop Details")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.imagePath.isNotEmpty)
              Image.file(File(widget.imagePath), height: 150),
            Text("Seller: ${widget.name}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Crop: ${widget.cropName}"),
            Text("Quantity: ${widget.quantity} Kg"),
            Text("Price: ₹${widget.price}"),
            SizedBox(height: 20),
            Text("Place Your Bid:", style: TextStyle(fontSize: 18)),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Enter Bid Amount"),
              onSubmitted: (value) => placeBid(value),
            ),
            SizedBox(height: 20),
            Text("Bidding History:", style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: bidHistory.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(bidHistory[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
