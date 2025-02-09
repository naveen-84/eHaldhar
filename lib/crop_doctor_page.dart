import 'package:flutter/material.dart';

class CropDoctorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crop Doctor")),
      body: Center(
        child: Text(
          "Crop Doctor Page Content",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
