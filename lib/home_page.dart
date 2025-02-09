import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'profile_page.dart.dart'; // Import profile page
import 'dart:math'; // Import for min() function
import 'weather_page.dart';
import 'mandi_page.dart';
import 'cart_page.dart';
import 'blog_page.dart';
import 'categories_page.dart'; // ✅ Import Categories Page
import 'crop_doctor_page.dart'; // ✅ Import Crop Doctor Page
import 'sell_crop_page.dart';
import 'buyer_page.dart';
import 'add_product_page.dart';
import 'crop_care_page.dart';
import 'crop_protection_page.dart';

class Product {
  final int id;
  final String name;
  final String image;
  final double price;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "Hi User! 👋";
  File? profileImage;
  String searchQuery = "";
  String activeTab = "Home";
  List<Product> cartItems = []; // Define cartItems list

  List<Map<String, dynamic>> features = [
    {'id': 1, 'title': 'Weather Forecast', 'icon': Icons.cloud_outlined},
    {'id': 2, 'title': 'Mandi Rate', 'icon': Icons.attach_money},
  ];
  final List<Map<String, dynamic>> services = [
    {
      'title': 'Sell Crop',
      'icon': 'assets/images/3830895.jpg',
      'route': SellCropPage()
    },
    {
      'title': 'Buyer',
      'icon': 'assets/images/th.jpg',
      'route': BuyerPage()
    }, // ✅ Added
    {
      'title': 'Add Product',
      'icon': 'assets/images/1164298.webp',
      'route': (context) => AddProductPage(onProductAdded: (product) {
            print("New Product Added: $product");
          })
    },
// ✅ Added
    {
      'title': 'Crop Care',
      'icon': 'assets/images/Crop-Care.png',
      'route': CropCarePage()
    },
    {
      'title': 'Crop Protection',
      'icon': 'assets/images/Crop-Protection.jpg',
      'route': CropProtectionPage()
    },
  ];

  List<Product> products = [
    Product(
        id: 1,
        name: "Neno Urea",
        image: "assets/images/Neno-Urea.webp",
        price: 270.00,
        quantity: 100),
    Product(
        id: 2,
        name: "Neno DAP",
        image: "assets/images/Neno-DAP.jpg",
        price: 650.00,
        quantity: 100),
    Product(
        id: 3,
        name: "Mustard",
        image: "assets/images/pioneer-mustard-seed-45s42.jpg",
        price: 900.00,
        quantity: 10),
    Product(
        id: 4,
        name: "Wheat",
        image: "assets/images/wheat.jpg",
        price: 2100.00,
        quantity: 10),
    Product(
        id: 5,
        name: "SunFlower",
        image: "assets/images/SunFlower.jpg",
        price: 1600.00,
        quantity: 10),
  ];

  void addToCart(Product product) {
    if (product.quantity == 0) return; // Prevent adding out-of-stock items

    setState(() {
      var productIndex = products.indexWhere((p) => p.id == product.id);
      if (productIndex != -1) {
        products[productIndex]
            .quantity--; // Update the product's stock quantity
      }

      var existingItem = cartItems.firstWhere(
        (item) => item.id == product.id,
        orElse: () =>
            Product(id: -1, name: "", image: "", price: 0, quantity: 0),
      );

      if (existingItem.id != -1) {
        existingItem.quantity++;
      } else {
        cartItems.add(Product(
          id: product.id,
          name: product.name,
          image: product.image,
          price: product.price,
          quantity: 1,
        ));
      }
      // Show a message when an item is added to the cart
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${product.name} added to your cart!"),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating, // Floating style Snackbar
          backgroundColor: Colors.green, // Optional: change color
        ),
      );
    });
  }

  void navigateToPage(String page) {
    print("Navigating to: $page"); // Debugging

    Widget targetPage;
    if (page == "Categories") {
      targetPage = CategoriesPage();
    } else if (page == "Crop Doctor") {
      targetPage = CropDoctorPage();
    } else if (page == "Blog") {
      targetPage = BlogPage();
    } else {
      print("Invalid Page: $page");
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => targetPage),
    );
  }

  void handleNavigationPress(String tab) {
    setState(() {
      activeTab = tab;
    });
  }

  void navigateToFeature(String feature) {
    if (feature == "Weather Forecast") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => WeatherPage()));
    } else if (feature == "Mandi Rate") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MandiPage()));
    }
  }

  void updateStock(Product product, int change) {
    setState(() {
      var originalProduct = products.firstWhere((p) => p.id == product.id);
      originalProduct.quantity += change; // Restore stock quantity
    });
  }

  void navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CartPage(cartItems: cartItems, updateStock: updateStock),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load saved name & profile image
  }

  // Load user data (name & image) from SharedPreferences
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = "Hi ${prefs.getString('user_name') ?? 'User'}! 👋";
      String? imagePath = prefs.getString('profile_image');
      if (imagePath != null) {
        profileImage = File(imagePath);
      }
    });
  }

  // Navigate to the profile page and refresh data on return
  void navigateToProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
    _loadUserData(); // Reload the profile after returning
  }

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = products.where((product) {
      return product.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Color(0xFFFFEFEB), // Change background color here
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  profileImage != null ? FileImage(profileImage!) : null,
              child: profileImage == null ? Icon(Icons.person) : null,
            ),
            SizedBox(width: 10),
            Text(userName),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: navigateToCart,
              ),
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 5,
                  top: 5,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      cartItems.length.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
          // IconButton(
          //   icon: Icon(Icons.person),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => ProfilePage()),
          //     ).then((_) => _loadUserData()); // Refresh after returning
          //   },
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: "Search for products...",
                  prefixIcon: Icon(Icons.search),
                  filled: true, // Ensures the background color is applied
                  fillColor: Colors.white, // Sets the background color to white
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onChanged: (text) {
                  setState(() {
                    searchQuery = text;
                  });
                },
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: features.map((feature) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => navigateToFeature(feature['title']),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 221, 223, 226),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Icon(feature['icon'],
                                color: Color.fromARGB(255, 0, 0, 0), size: 30),
                            SizedBox(height: 5),
                            Text(feature['title'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              // Services Options
              Text(
                "Our Services",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 10), // Adds space above & below
                child: SizedBox(
                  height: 120, // Adjust height for box size
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            if (services[index]['route'] != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        services[index]['route']),
                              );
                            }
                          },
                          child: Container(
                            width: 100,
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 221, 223, 226),
                              borderRadius: BorderRadius.circular(10),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.grey.shade400,
                              //     blurRadius: 5,
                              //     spreadRadius: 2,
                              //     offset: Offset(5, 8), // Shadow on top
                              //   ),
                              //   BoxShadow(
                              //     color: Colors.grey.shade400,
                              //     blurRadius: 5,
                              //     spreadRadius: 2,
                              //     offset: Offset(0, 3), // Shadow on bottom
                              //   ),
                              // ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipOval(
                                  // Makes the image circular
                                  child: Image.asset(
                                    services[index]['icon'], // Display image
                                    height: 65, // Adjust size
                                    width: 65,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  services[index]['title'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ));
                    },
                  ),
                ),
              ),

              SizedBox(height: 20),
              Container(
                // color: Colors.grey[200], // Set background color to gray
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Best Selling Products",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: products.take(5).map((product) {
                          // Display 5 Best Selling Products
                          return Card(
                            color: Color.fromARGB(255, 221, 223, 226),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    product.image,
                                    height: 70,
                                    width: 70,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(height: 5),
                                  Text(product.name,
                                      textAlign: TextAlign.center),
                                  Text("₹${product.price}",
                                      style: TextStyle(color: Colors.green)),
                                  ElevatedButton(
                                    onPressed: product.quantity > 0
                                        ? () => addToCart(product)
                                        : null,
                                    child: Text(product.quantity > 0
                                        ? "Add to Cart"
                                        : "Out of Stock"),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              /// ✅ NEW SECTION: RECENTLY ADDED PRODUCTS
              Text("Recently Added Products",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: min(products.length, 6), // Show latest 6 products
                itemBuilder: (context, index) {
                  Product product =
                      products.reversed.toList()[index]; // Show recent first

                  return Card(
                    color: Color.fromARGB(255, 221, 223, 226),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.asset(
                            product.image,
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(product.name, textAlign: TextAlign.center),
                        Text("₹${product.price}",
                            style: TextStyle(color: Colors.green)),
                        ElevatedButton(
                          onPressed: product.quantity > 0
                              ? () => addToCart(product)
                              : null,
                          child: Text(product.quantity > 0
                              ? "Add to Cart"
                              : "Out of Stock"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 247, 138, 138),
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.black,
        currentIndex: ['Home', 'Categories', 'Crop Doctor', 'Blog', 'Profile']
            .indexOf(activeTab),
        onTap: (index) {
          String selectedTab =
              ['Home', 'Categories', 'Crop Doctor', 'Blog', 'Profile'][index];

          if (selectedTab == "Profile") {
            navigateToProfile();
          } else if (selectedTab == "Categories" ||
              selectedTab == "Crop Doctor" ||
              selectedTab == "Blog") {
            navigateToPage(selectedTab);
          } else {
            setState(() {
              activeTab = selectedTab;
            });
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: "Categories"),
          BottomNavigationBarItem(
              icon: Icon(Icons.medical_services), label: "Crop Doctor"),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: "Blog"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
