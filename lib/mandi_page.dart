import 'package:flutter/material.dart';

class MandiPage extends StatelessWidget {
  final List<Map<String, dynamic>> mandiRates = [
    {'crop': 'Wheat', 'price': '₹2200/Quintal'},
    {'crop': 'Rice', 'price': '₹3000/Quintal'},
    {'crop': 'Corn', 'price': '₹1800/Quintal'},
    {'crop': 'Soybean', 'price': '₹4200/Quintal'},
    {'crop': 'Mustard', 'price': '₹5000/Quintal'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mandi Rates"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Latest Mandi Prices",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: mandiRates.length,
                itemBuilder: (context, index) {
                  var mandi = mandiRates[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.agriculture, color: Colors.green),
                      title: Text(mandi['crop'],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(mandi['price'],
                          style: TextStyle(color: Colors.green)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
