import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MenuScreenEdit extends StatefulWidget {
  const MenuScreenEdit({Key? key}) : super(key: key);

  @override
  State<MenuScreenEdit> createState() => _MenuScreenStateEdit();
}

class _MenuScreenStateEdit extends State<MenuScreenEdit> {
  final _formKey = GlobalKey<FormState>();

  String _nama = '';
  String _deskripsi = '';
  double _harga = 0.0;
  int _stok = 0;
  String _kategori = '';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Form is valid, perform your submission logic here
      // You can access the form values using the variables _nama, _deskripsi, _harga, _stok, _kategori
      // Example: Send an HTTP request to your API to update the product data

      // Create the request body
      final requestBody = {
        'nama': _nama,
        'deskripsi': _deskripsi,
        'harga': _harga.toString(),
        'stok': _stok.toString(),
        'kategori': _kategori,
      };

      // Send the POST request
      final url = Uri.parse('https://api.couplemoment.com/product/edit');
      final response = await http.post(url, body: requestBody);

      // Check the response status
      if (response.statusCode == 200) {
        // Request successful, do something with the response
        print('Product updated successfully');
      } else {
        // Request failed, handle the error
        print('Failed to update product');
      }

      // Reset the form
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Menu'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nama',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nama = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _deskripsi = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Harga',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the price';
                  }
                  return null;
                },
                onSaved: (value) {
                  _harga = double.parse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Stok',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the stock';
                  }
                  return null;
                },
                onSaved: (value) {
                  _stok = int.parse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Kategori',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the category';
                  }
                  return null;
                },
                onSaved: (value) {
                  _kategori = value!;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
