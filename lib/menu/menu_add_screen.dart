import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:uipos2/theme/cappbar.dart';
import 'package:uipos2/mainmenu/home_screen.dart';
import 'package:uipos2/mainmenu/menu_screen.dart';
import 'package:uipos2/mainmenu/payment_screen.dart';
import 'package:uipos2/mainmenu/order_screen.dart';
import 'package:uipos2/mainmenu/account_screen.dart';
import 'package:uipos2/theme/bottomnavbar.dart';
import 'package:uipos2/theme/textinputform.dart';

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
      final gambar = _image!.path;

      // Prepare the data to be sent as JSON
      final jsonData = jsonEncode({
        'nama': nama,
        'deskripsi': deskripsi,
        'harga': harga,
        'stok': stok,
        'gambar': gambar,
      });

      // final url = Uri.parse('https://api.couplemoment.com/product/add');

      // final request = http.MultipartRequest('POST', url);

      // request.headers['Content-Type'] = 'multipart/form-data';

      // // Add the JSON data
      // request.fields['data'] = jsonData;

      // // Create a multipart request
      // // Add the image file
      // final imagePath =
      //     'path_to_your_image.jpg'; // Replace with the actual image file path
      // final imageFile = await http.MultipartFile.fromPath(
      //   'gambar',
      //   imagePath,
      //   contentType: MediaType('image',
      //       'jpeg, jpg, png'), // Adjust the content type based on your image file
      // );
      // request.files.add(imageFile);

      // // Send the request
      // final response = await request.send();

      // final responseString = await response.stream.bytesToString();

      // print(responseString);

      // Send the JSON data as the request body
      final response = await http.post(
        Uri.parse(
            'https://api.couplemoment.com/product/add'), // Replace with your API endpoint
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
                      'Berhasil',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text('Produk berhasil ditambahkan'),
                    SizedBox(height: 16.0),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MenuScreen()),
                        );
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
                      'Gagal',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text('Produk gagal ditambahkan'),
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
        title: 'Produk',
        breadcrumbItem: 'Produk',
        breadcrumbItem2: 'Tambah Produk',
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
                CustomInputField(
                  controller: _nameController,
                  labelText: 'Nama Produk',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nama produk tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                CustomInputField(
                  controller: _descriptionController,
                  labelText: 'Deskripsi Produk',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Deskripsi produk tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                CustomInputField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  labelText: 'Harga Produk',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Harga produk tidak boleh kosong';
                    }

                    var cleanedValue = value.replaceAll(RegExp(r'[Rp.,]'), '');
                    // Remove "Rp.", comma (",") and any other characters

                    if (cleanedValue.length == 1) {
                      // Add leading zero if the input contains a single digit
                      cleanedValue = '0' + cleanedValue;
                    }

                    final price = double.tryParse(cleanedValue);

                    if (price == null || price <= 0) {
                      return 'Harga produk tidak valid';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                CustomInputField(
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  labelText: 'Stok Produk',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Stok produk tidak boleh kosong';
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
                                title: Text('Ambil foto',
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
                                title: Text('Pilih dari galeri',
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
                        'Pilih Gambar',
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
                        'Tambah Produk',
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
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
