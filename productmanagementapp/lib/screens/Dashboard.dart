import 'dart:convert';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:productmanagementapp/screens/ProductManagement.dart';
import 'package:productmanagementapp/screens/ResertPasword.dart'; // Import the intl package for DateFormat

class Dashboard extends StatelessWidget {
  final String userEmail;

  Dashboard({required this.userEmail});

  static const header = 'Add new product';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: header,
      home: MyHomePage(userEmail: userEmail, title: header),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final String userEmail;

  const MyHomePage({Key? key, required this.title, required this.userEmail})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _qrCodeController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _expiredAtController = TextEditingController();
  final TextEditingController _volumeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _addProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/products'),
        body: {
          'code': _qrCodeController.text,
          'category': _categoryController.text,
          'quantity': _quantityController.text,
          'brand': _brandController.text,
          'description': _descriptionController.text,
          'expired_at': _expiredAtController.text,
          'volume': _volumeController.text,
        },
      );

      if (response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: 'Product added successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        // Clear form fields after successful addition
        _qrCodeController.clear();
        _categoryController.clear();
        _quantityController.clear();
        _brandController.clear();
        _descriptionController.clear();
        _expiredAtController.clear();
        _volumeController.clear();
      } else {
        final responseData = json.decode(response.body);
        Fluttertoast.showToast(
          msg: responseData['message'] ?? 'Failed to add product',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Something went wrong',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Text(widget.userEmail),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Text(
                'USER MENU',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              leading: Icon(Icons.face_unlock_outlined),
              title: Text('Reset password'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResetPassword()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Products'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductLsts()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Implement Logout logic
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Card(
            color: Colors.white,
            elevation: 1,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _qrCodeController,
                      decoration: InputDecoration(labelText: 'QR Code'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter QR code';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _categoryController,
                      decoration: InputDecoration(labelText: 'Category'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter category';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _quantityController,
                      decoration: InputDecoration(labelText: 'Quantity'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter quantity';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _brandController,
                      decoration: InputDecoration(labelText: 'Brand'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter brand';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    DateTimeField(
                      controller: _expiredAtController,
                      decoration: InputDecoration(labelText: 'Expired At'),
                      format: DateFormat(
                          "yyyy-MM-dd"), // Use DateFormat from intl package
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter expiry date';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _volumeController,
                      decoration: InputDecoration(labelText: 'Volume'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter volume';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _addProduct,
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text('Add Product'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
