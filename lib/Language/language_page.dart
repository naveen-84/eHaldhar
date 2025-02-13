import 'package:flutter/material.dart';
import '../SignUpScreen/signup_page.dart'; // Import your next page

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String? selectedLanguage;

  // Function to handle language selection
  void handleLanguageSelection(String language) {
    setState(() {
      selectedLanguage = language;
    });
    print("Selected language: $language");
  }

  // Function to navigate to the next page
  void handleNextPage() {
    if (selectedLanguage != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignUpPage()),
      );
    } else {
      print("Please select a language.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5DC), // Light beige background
      appBar: AppBar(
        title: Center(
          // Center the title
          child: Text(
            "Select Your Language",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 242, 162, 1),
      ),
      body: SingleChildScrollView(
        // Wrap the entire body with SingleChildScrollView for scrolling
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 25),
              Center(
                // Center the language selection buttons
                child: Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  alignment: WrapAlignment.center,
                  children: [
                    languageButton("English", "English"),
                    languageButton("Hindi", "हिन्दी"),
                    languageButton("Marathi", "मराठी"),
                    languageButton("Urdu", "اردو"),
                    languageButton("Punjabi", "ਪੰਜਾਬੀ"),
                    languageButton("Tamil", "தமிழ்"),
                    languageButton("Gujarati", "ગુજરાતી"),
                    languageButton("Bengali", "বাংলা"),
                  ],
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: handleNextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 150, vertical: 15),
                ),
                child: Text("Next",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    )),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget languageButton(String language, String nativeName) {
    return GestureDetector(
      onTap: () => handleLanguageSelection(language),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selectedLanguage == language ? Colors.green : Colors.orange,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              language,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              nativeName,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
