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

class MenuScreenEdit extends StatefulWidget {
  final String idProduct;

  const MenuScreenEdit({Key? key, required this.idProduct}) : super(key: key);

  @override
  State<MenuScreenEdit> createState() => _MenuScreenStateEdit();
}

class _MenuScreenStateEdit extends State<MenuScreenEdit> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  XFile? _image;

  @override
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
      final harga = double.parse(_priceController.text);
      final stok = int.parse(_stockController.text);

      // Prepare the data to be sent as JSON
      final jsonData = jsonEncode({
        'nama': nama,
        'deskripsi': deskripsi,
        'harga': harga,
        'stok': stok,
      });

      // Send the PUT request
      final url =
          Uri.parse('http://192.168.1.8:3000/product/edit/$widget.idProduct');
      final response = await http.put(url, body: jsonData);

      // Check the response status
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Response body: $jsonData');

      if (response.statusCode == 200) {
        // Request successful, pass the updated data back to the detail screen
        Navigator.pop(
          context,
          {
            'nama': nama,
            'deskripsi': deskripsi,
            'harga': harga,
            'stok': stok,
          },
        );
      } else {
        // Request failed, handle the error
        print('Failed to update product');
      }

      // Reset the form
      _formKey.currentState!.reset();
    }
  }

  @override
  void initState() {
    super.initState();

    // Mendapatkan nilai awal menu dari API (misalnya dengan melakukan request HTTP)
    // dan mengatur nilai awal TextEditingControllers
    _fetchMenuData();
  }

  Future<void> _fetchMenuData() async {
    final url =
        Uri.parse('http://192.168.1.8:3000/product/${widget.idProduct}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData != null &&
          jsonData['data'] != null &&
          jsonData['data'].isNotEmpty) {
        final menuData = jsonData['data'][0];

        setState(() {
          _nameController.text = menuData['nama'] ?? '';
          _descriptionController.text = menuData['deskripsi'] ?? '';
          _priceController.text = menuData['harga']?.toString() ?? '';
          _stockController.text = menuData['stok']?.toString() ?? '';
        });

        print('Fetched Menu Data:');
        print('Nama: ${_nameController.text}');
        print('Deskripsi: ${_descriptionController.text}');
        print('Harga: ${_priceController.text}');
        print('Stok: ${_stockController.text}');
      } else {
        print('Failed to fetch menu data. JSON data is null or empty.');
      }
    } else {
      print(
          'Failed to fetch menu data. Response status code: ${response.statusCode}');
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
        breadcrumbItem2: 'Edit Menu',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
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
                    if (value == null || value.isEmpty) {
                      return 'Please enter product name';
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
                SizedBox(height: 16),
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
                SizedBox(height: 16),
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
                  Image.network(
                    _image!.path,
                    height: 200,
                    fit: BoxFit.cover,
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
                        'Edit Menu',
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
