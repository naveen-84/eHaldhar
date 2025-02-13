import 'package:flutter/material.dart';

class BlogPage extends StatefulWidget {
  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  List<Map<String, String>> blogPosts = [];

  void _submitPost() {
    if (_titleController.text.isNotEmpty &&
        _contentController.text.isNotEmpty) {
      setState(() {
        blogPosts.insert(0, {
          "title": _titleController.text,
          "content": _contentController.text,
        });
        _titleController.clear();
        _contentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Awesome Blog")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome to My Awesome Blog!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Title",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Content",
              ),
              maxLines: 4,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                padding: EdgeInsets.symmetric(vertical: 14),
                minimumSize: Size(double.infinity, 40),
              ),
              child: Text("Submit"),
            ),
            SizedBox(height: 20),
            Text(
              "Your Blog Posts:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: blogPosts.isEmpty
                  ? Center(child: Text("No blog posts yet."))
                  : ListView.builder(
                      itemCount: blogPosts.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(blogPosts[index]["title"]!),
                            subtitle: Text(blogPosts[index]["content"]!),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view), label: "Categories"),
          BottomNavigationBarItem(
              icon: Icon(Icons.medical_services), label: "Crop Doctor"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Blog"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Cart"),
        ],
      ),
    );
  }
}
