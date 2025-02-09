import 'package:flutter/material.dart';
import 'home_page.dart'; // Import HomePage to access Product class

class CartPage extends StatefulWidget {
  final List<Product> cartItems;
  final Function(Product, int) updateStock; // Callback function

  CartPage({required this.cartItems, required this.updateStock});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void updateQuantity(Product product, int change) {
    setState(() {
      product.quantity += change;

      if (change < 0) {
        widget.updateStock(product, 1); // Increase real stock when removed
      } else if (change > 0) {
        widget.updateStock(product, -1); // Decrease real stock when added
      }

      if (product.quantity <= 0) {
        widget.cartItems.remove(product); // Remove if quantity reaches 0
      }
    });
  }

  double calculateTotal() {
    return widget.cartItems
        .fold(0, (total, item) => total + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Cart")),
      body: widget.cartItems.isEmpty
          ? Center(child: Text("Your cart is empty!"))
          : ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                Product product = widget.cartItems[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.asset(product.image, height: 50, width: 50),
                    title: Text(product.name),
                    subtitle: Text("₹${product.price} x ${product.quantity}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: () => updateQuantity(product, -1),
                        ),
                        Text(product.quantity.toString()),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: () => updateQuantity(product, 1),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey, width: 1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Total: ₹${calculateTotal().toStringAsFixed(2)}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {}, // Add checkout functionality
              child: Text("Proceed to Checkout"),
            ),
          ],
        ),
      ),
    );
  }
}
