import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:uipos2/signin_screen.dart';
import 'package:uipos2/landing_page.dart';
import 'package:uipos2/signup_screen.dart';
import 'package:uipos2/cappbar.dart';
import 'package:uipos2/mainmenu/home_screen.dart';
import 'package:uipos2/mainmenu/menu_screen.dart';
import 'package:uipos2/mainmenu/payment_screen.dart';
import 'package:uipos2/mainmenu/order_screen.dart';
import 'package:uipos2/mainmenu/account_screen.dart';
import 'package:uipos2/menu/menu_add_screen.dart';
import 'package:uipos2/menu/menu_detail_screen.dart';

class MenuScreenAdd extends StatefulWidget {
  const MenuScreenAdd({Key? key}) : super(key: key);

  @override
  State<MenuScreenAdd> createState() => _MenuScreenStateAdd();
}

class _MenuScreenStateAdd extends State<MenuScreenAdd> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _stockController = TextEditingController();
  XFile? _image;

  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final nama = _nameController.text;
      final deskripsi = _descriptionController.text;
      final harga = _priceController.text;
      final stok = _stockController.text;

      // Prepare the data to be sent as JSON
      final jsonData = jsonEncode({
        'nama': nama,
        'deskripsi': deskripsi,
        'harga': harga,
        'stok': stok,
      });

      // Send the JSON data as the request body
      final response = await http.post(
        Uri.parse(
            'http://192.168.1.8:3000/product/add'), // Replace with your API endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonData,
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Success',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text('Product added successfully!'),
                    SizedBox(height: 16.0),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Error',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text('Failed to add product'),
                    SizedBox(height: 16.0),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }

      _nameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      _stockController.clear();
      _image = null;
    }
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });
    }
  }

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else if (index == 1) {
      // Stay on MenuScreen
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PaymentScreen()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrderScreen()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AccountScreen()),
      );
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Menu',
        breadcrumbItem: 'Menu',
        breadcrumbItem2: 'Add Menu',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    labelStyle:
                        TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(
                        color: Color.fromARGB(188, 209, 0, 0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(
                        color: Color.fromARGB(188, 209, 0, 0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(
                        color: Color.fromARGB(188, 209, 0, 0),
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your product name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _descriptionController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Description of Product',
                    labelStyle:
                        TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(
                        color: Color.fromARGB(188, 209, 0, 0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(
                        color: Color.fromARGB(188, 209, 0, 0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(
                        color: Color.fromARGB(188, 209, 0, 0),
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Price of Product',
                    labelStyle:
                        TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(
                        color: Color.fromARGB(188, 209, 0, 0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(
                        color: Color.fromARGB(188, 209, 0, 0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(
                        color: Color.fromARGB(188, 209, 0, 0),
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your price of product';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Stock of Product',
                    labelStyle:
                        TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(
                        color: Color.fromARGB(188, 209, 0, 0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(
                        color: Color.fromARGB(188, 209, 0, 0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(
                        color: Color.fromARGB(188, 209, 0, 0),
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your stock of product';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.camera,
                                    color: Colors.black), // Add icon
                                title: Text('Take a photo',
                                    style: TextStyle(
                                        color: Colors.black)), // Add text style
                                onTap: () {
                                  _pickImage(ImageSource.camera);
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.image,
                                    color: Colors.black), // Add icon
                                title: Text('Choose from gallery',
                                    style: TextStyle(
                                        color: Colors.black)), // Add text style
                                onTap: () {
                                  _pickImage(ImageSource.gallery);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.photo, color: Colors.white), // Add icon
                      SizedBox(width: 8),
                      Text(
                        'Choose Image',
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    minimumSize: const Size(300, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    backgroundColor: const Color.fromARGB(188, 209, 0, 0),
                    fixedSize: const Size(300, 50),
                  ),
                ),
                SizedBox(height: 16),
                if (_image != null)
                  Image.file(
                    File(_image!.path),
                    height: 200.0,
                  )
                else
                  Container(),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white), // Add icon
                      SizedBox(width: 8),
                      Text(
                        'Add Menu',
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    minimumSize: const Size(300, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    backgroundColor: const Color.fromARGB(188, 209, 0, 0),
                    fixedSize: const Size(300, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: Color.fromARGB(188, 209, 0, 0),
              radius: 30,
              child: Icon(Icons.qr_code, color: Colors.white, size: 30),
            ),
            label: 'Payment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(188, 209, 0, 0),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedFontSize: 13.0,
        unselectedFontSize: 13.0,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
        ),
        onTap: _onItemTapped,
      ),
    );
  }
}
