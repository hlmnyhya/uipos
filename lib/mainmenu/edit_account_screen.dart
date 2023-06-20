import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uipos2/theme/textinputform.dart';

class EditAccountForm extends StatefulWidget {
  @override
  _EditAccountFormState createState() => _EditAccountFormState();
}

class _EditAccountFormState extends State<EditAccountForm> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  late String _token; // Variable to store the token

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    // Fetch data from API
    fetchData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('https://api.couplemoment.com/user'),
      headers: {
        'Authorization': 'Bearer $_token'
      }, // Include the token in the header
    );
    if (response.statusCode == 200) {
      // Parsing the response data
      final data = jsonDecode(response.body);

      print(data);

      // Extract name and email from the response data
      final name = data['name'];
      final email = data['email'];

      // Updating the text fields with the retrieved data
      setState(() {
        _nameController.text = name;
        _emailController.text = email;
      });
    } else {
      // Handle error if API request fails
      print('Failed to fetch data from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "''Kami sebagai pengembang aplikasi ''Olseller'', dengan sepenuh hati berkomitmen untuk membantu UMKM dalam mengelola bisnis mereka dengan lebih efisien dan mudah. Aplikasi kami didesain khusus untuk memberikan solusi terbaik, mulai dari dokumentasi penjualan, pembayaran online, hingga grafik penjualan. Dengan aplikasi kami, UMKM dapat dengan cepat melacak stok, mengelola transaksi, dan memberikan rekomendasi produk favorit. Kami berharap aplikasi kami dapat menjadi mitra terpercaya bagi UMKM dalam meraih kesuksesan dan pertumbuhan yang berkelanjutan.''",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // SizedBox(height: 250),
          ],
        ),
      ),
    );
  }
}
