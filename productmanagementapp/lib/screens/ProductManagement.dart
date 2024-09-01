import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'Dashboard.dart';

class Product {
  final String code;
  final String category;
  final int quantity;
  final String brand;
  final String description;
  final String expired_at;
  final double volume;
  final String created_at;

  Product({
    required this.code,
    required this.category,
    required this.quantity,
    required this.brand,
    required this.description,
    required this.expired_at,
    required this.volume,
    required this.created_at,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      code: json['code'] ?? '',
      category: json['category'] ?? '',
      quantity: json['quantity'] ?? 0,
      brand: json['brand'] ?? '',
      description: json['description'] ?? '',
      expired_at: json['expired_at'] ?? '',
      volume: json['volume'] != null ? double.parse(json['volume'].toString()) : 0.0,
      created_at: json['created_at'] ?? '',
    );
  }
}

void main() {
  runApp(ProductLsts());
}

class ProductLsts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;
  List<Product> products = [];

  Future<void> fetchProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/products'));

      if (response.statusCode == 200) {
        List<dynamic>? responseBody = jsonDecode(response.body);

        if (responseBody != null) {
          setState(() {
            products = responseBody.map((e) => Product.fromJson(e)).toList();
            _isLoading = false;
            checkExpiredProducts();
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          Fluttertoast.showToast(
            msg: "No products found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(
          msg: "Failed to fetch products",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print(error);
      Fluttertoast.showToast(
        msg: "Something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void checkExpiredProducts() {
    final now = DateTime.now();
    for (var product in products) {
      final expirationDate = DateTime.parse(product.expired_at);
      if (expirationDate.isBefore(now)) {
        Fluttertoast.showToast(
          msg: "Product ${product.code} has expired",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5, // Duration in seconds
        );
      }
    }
  }

  @override
  void initState() {
    fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Products',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Expired Products'),
              onTap: () {
                // Navigate to expired products page
              },
            ),
            ListTile(
              title: Text('Back-home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Dashboard(userEmail: '')),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            // Card before the table
            Card(
              color: Colors.blueAccent,
              margin: EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Product Summary',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // DataTable for product details
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('QR Code')),
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Brand')),
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Text('Expired At')),
                  DataColumn(label: Text('Volume')),
                  DataColumn(label: Text('Created At')),
                ],
                rows: products.map((product) {
                  return DataRow(cells: [
                    DataCell(Text(product.code)),
                    DataCell(Text(product.category)),
                    DataCell(Text(product.quantity.toString())),
                    DataCell(Text(product.brand)),
                    DataCell(Text(product.description)),
                    DataCell(Text(product.expired_at)),
                    DataCell(Text(product.volume.toString())),
                    DataCell(Text(product.created_at)),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
