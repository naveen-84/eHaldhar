import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<Map<String, dynamic>> categories = [
    {
      "id": "2",
      "name": "Fertilizers",
      "image": "assets/images/Radish.jpg",
      "dropdownOptions": [
        "Nano Fertilizers",
        "Water Soluble Fertilizers",
        "Speciality Fertilizers",
      ],
    },
    {
      "id": "3",
      "name": "Seeds",
      "image": "assets/images/Radish.jpg",
      "dropdownOptions": [
        "Vegetable Seeds",
        "Field Crop Seeds",
        "Fruit Seeds",
        "Flower Seeds",
      ],
    },
    {
      "id": "4",
      "name": "Organic Products",
      "image": "assets/images/Radish.jpg",
      "dropdownOptions": [
        "Bio Fertilizers",
        "Plant Growth Promoters",
        "Biopesticides",
        "Organic Fertilizers",
      ],
    },
  ];

  Set<String> expandedCategories = {};

  void toggleDropdown(String categoryId) {
    setState(() {
      if (expandedCategories.contains(categoryId)) {
        expandedCategories.remove(categoryId);
      } else {
        expandedCategories.add(categoryId);
      }
    });
  }

  void navigateToCategory(BuildContext context, String option) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryDetailsScreen(category: option),
      ),
    );
  }

  void navigateToPage(BuildContext context, String page) {
    print("Navigating to $page");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
          ),
          ...categories.map((category) {
            return Column(
              children: [
                ListTile(
                  leading:
                      Image.asset(category["image"], width: 50, height: 50),
                  title: Text(category["name"], style: TextStyle(fontSize: 18)),
                  trailing: category["dropdownOptions"].isNotEmpty
                      ? Icon(expandedCategories.contains(category["id"])
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down)
                      : null,
                  onTap: () => toggleDropdown(category["id"]),
                ),
                Divider(),
                if (expandedCategories.contains(category["id"]) &&
                    category["dropdownOptions"].isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children:
                          category["dropdownOptions"].map<Widget>((option) {
                        return ListTile(
                          title: Text(option),
                          onTap: () => navigateToCategory(context, option),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            );
          }).toList(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 0) navigateToPage(context, "Home");
          if (index == 1) navigateToPage(context, "Categories");
          if (index == 2) navigateToPage(context, "Account");
          if (index == 3) navigateToPage(context, "Blog");
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: "Blog"),
        ],
      ),
    );
  }
}

class CategoryDetailsScreen extends StatelessWidget {
  final String category;
  CategoryDetailsScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: Center(
          child: Text("Details for $category", style: TextStyle(fontSize: 22))),
    );
  }
}
