import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // Import for File
import 'crop_listing_page.dart';

XFile? _image; // Variable to store selected image
final ImagePicker picker = ImagePicker(); // Image Picker instance

class SellCropPage extends StatefulWidget {
  @override
  _SellCropPageState createState() => _SellCropPageState();
}

class _SellCropPageState extends State<SellCropPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController aadharController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController houseNumberController = TextEditingController();
  TextEditingController villageCityController = TextEditingController();
  TextEditingController postOfficeController = TextEditingController();
  TextEditingController tehsilController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController cropNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController reAccountNumberController = TextEditingController();

  String gender = "";
  String state = "";
  bool showAddressDetails = false;
  bool showCropDetails = false;
  bool showBankDetails = false;

  /// Function to fetch Bank Details using IFSC code
  Future<void> fetchBankDetails(String ifsc) async {
    final url = Uri.parse('https://ifsc.razorpay.com/$ifsc');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          bankNameController.text = data['BANK'];
          branchNameController.text = data['BRANCH'];
        });
      } else {
        print("Invalid IFSC Code");
      }
    } catch (e) {
      print("Error fetching IFSC details: $e");
    }
  }

  /// Function to fetch location details using Pincode
  Future<void> fetchPincodeDetails(String pincode) async {
    final url = Uri.parse('https://api.postalpincode.in/pincode/$pincode');

    try {
      final response = await http.get(url);
      final data = json.decode(response.body);
      if (data[0]['Status'] == "Success") {
        setState(() {
          districtController.text = data[0]['PostOffice'][0]['District'];
          stateController.text = data[0]['PostOffice'][0]['State'];
        });
      } else {
        print("Invalid Pincode");
      }
    } catch (e) {
      print("Error fetching pincode details: $e");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  void handleSubmit() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CropListingPage(
            name: nameController.text,
            cropName: cropNameController.text,
            quantity: quantityController.text,
            price: priceController.text,
            imagePath: _image?.path ?? "",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sell Crop")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Personal Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: aadharController,
                decoration: InputDecoration(labelText: "Aadhar Number"),
                keyboardType: TextInputType.number,
                maxLength: 12,
                validator: (value) {
                  if (value == null || value.length != 12) {
                    return "Enter valid Aadhar Number";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Gender"),
                items: ["Male", "Female", "Other"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    gender = value!;
                  });
                },
              ),
              TextFormField(
                controller: dobController,
                decoration:
                    InputDecoration(labelText: "Date of Birth (DD-MM-YYYY)"),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () =>
                    setState(() => showAddressDetails = !showAddressDetails),
                child: Text("Address Details",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              if (showAddressDetails) ...[
                TextFormField(
                    controller: houseNumberController,
                    decoration: InputDecoration(labelText: "House Number")),
                TextFormField(
                    controller: villageCityController,
                    decoration: InputDecoration(labelText: "Village/City")),
                TextFormField(
                    controller: postOfficeController,
                    decoration: InputDecoration(labelText: "Post Office")),
                TextFormField(
                    controller: tehsilController,
                    decoration: InputDecoration(labelText: "Tehsil")),
                TextFormField(
                    controller: districtController,
                    decoration: InputDecoration(labelText: "District"),
                    enabled: false),
                TextFormField(
                    controller: stateController,
                    decoration: InputDecoration(labelText: "State"),
                    enabled: false),
                TextFormField(
                    controller: pincodeController,
                    decoration: InputDecoration(labelText: "Pincode"),
                    keyboardType: TextInputType.number,
                    maxLength: 6),
              ],
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => setState(() => showCropDetails = !showCropDetails),
                child: Text("Crop Details",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              if (showCropDetails) ...[
                TextFormField(
                    controller: cropNameController,
                    decoration: InputDecoration(labelText: "Crop Name")),
                TextFormField(
                    controller: quantityController,
                    decoration: InputDecoration(labelText: "Quantity (Kg)"),
                    keyboardType: TextInputType.number),
                TextFormField(
                    controller: priceController,
                    decoration: InputDecoration(labelText: "Price (₹)"),
                    keyboardType: TextInputType.number),
              ],
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => setState(() => showBankDetails = !showBankDetails),
                child: Text("Bank Details",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              if (showBankDetails) ...[
                TextFormField(
                    controller: ifscController,
                    decoration: InputDecoration(labelText: "IFSC Code")),
                TextFormField(
                    controller: bankNameController,
                    decoration: InputDecoration(labelText: "Bank Name"),
                    enabled: false),
                TextFormField(
                    controller: branchNameController,
                    decoration: InputDecoration(labelText: "Branch Name"),
                    enabled: false),
                TextFormField(
                    controller: accountNumberController,
                    decoration: InputDecoration(labelText: "Account Number"),
                    keyboardType: TextInputType.number),
                TextFormField(
                  controller: reAccountNumberController,
                  decoration: InputDecoration(
                    labelText: "Re-enter Account Number",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please re-enter the account number";
                    }
                    if (value != accountNumberController.text) {
                      return "Account numbers do not match";
                    }
                    return null;
                  },
                ),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text("Upload Product Photo"),
              ),
              if (_image != null)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.file(File(_image!.path), height: 150),
                ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: handleSubmit,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
