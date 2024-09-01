import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(ProductScanner());
}

class ProductScanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ScanProduct(),
    );
  }
}

class ScanProduct extends StatefulWidget {
  @override
  _ScanProductState createState() => _ScanProductState();
}

class _ScanProductState extends State<ScanProduct> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  TextEditingController qrCodeController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController expiredAtController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    controller?.dispose();
    qrCodeController.dispose();
    categoryController.dispose();
    quantityController.dispose();
    brandController.dispose();
    descriptionController.dispose();
    expiredAtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: qrCodeController,
              decoration: InputDecoration(
                labelText: 'Scanned QR Code',
              ),
            ),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(
                labelText: 'Category',
              ),
            ),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(
                labelText: 'Quantity',
              ),
            ),
            TextField(
              controller: brandController,
              decoration: InputDecoration(
                labelText: 'Brand',
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            TextField(
              controller: expiredAtController,
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    expiredAtController.text = pickedDate
                        .toIso8601String(); // Format the date as ISO 8601 string
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Expired At',
              ),
            ),
            ElevatedButton(
              onPressed: _loading ? null : submitForm,
              child: _loading ? CircularProgressIndicator() : Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrCodeController.text =
            scanData.code!; // Use scanData.code to get the actual scanned data
      });
    });
  }

  Future<void> submitForm() async {
    setState(() {
      _loading = true;
    });

    // Prepare the form data
    var formData = {
      'qr_code': qrCodeController.text,
      'category': categoryController.text,
      'quantity': quantityController.text,
      'brand': brandController.text,
      'description': descriptionController.text,
      'expired_at': expiredAtController.text,
    };

    // Make POST request to your Laravel server
    var apiUrl =
        'http://127.0.0.1:8000/api/register'; // Laravel API endpoint URL
    var response = await http.post(
      Uri.parse(apiUrl),
      body: formData,
    );

    // Check the response status
    if (response.statusCode == 200) {
      // Request successful, handle response
      var responseData = jsonDecode(response.body);
      // Do something with responseData if needed
      print('Response: $responseData');
      Fluttertoast.showToast(msg: 'Form submitted successfully');
    } else {
      // Request failed, handle error
      print('Error: ${response.reasonPhrase}');
      Fluttertoast.showToast(msg: 'Failed to submit form');
    }

    setState(() {
      _loading = false;
    });
  }
}
