import 'package:flutter/material.dart';
import 'package:uipos2/mainmenu/home_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final storage = FlutterSecureStorage();

  Future<void> login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      Map<String, dynamic> requestBody = {
        'email': email,
        'password': password,
      };

      var url = Uri.parse('https://couplemoment.com/user/login');

      var response = await http.post(url, body: requestBody);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        String? token = responseData['token'];

        if (token != null) {
          // Token berhasil dibaca, tambahkan token ke header authorization
          Map<String, String> headers = {
            'Authorization': 'Bearer $token',
          };

          // Kirim permintaan dengan header authorization
          var authenticatedResponse =
              await http.post(url, body: requestBody, headers: headers);

          // Token berhasil dibaca, Anda dapat menggunakan jwt_decoder untuk mendekode token
          print('Token: $token');

          // Simpan token ke penyimpanan yang aman
          await storage.write(key: 'token', value: token);
          // Baca kembali token dari penyimpanan
          String? storedToken = await storage.read(key: 'token');

          if (storedToken != null) {
            // Token berhasil dibaca dari penyimpanan
            print('Stored Token: $storedToken');

            // Decode token menggunakan jwt_decoder
            Map<String, dynamic> decodedToken = JwtDecoder.decode(storedToken);
            int? userId = decodedToken['id'];
            print(decodedToken);

            if (userId != null) {
              // Contoh: Menggunakan userId dalam logika aplikasi
              print('User ID: $userId');
            } else {
              // UserID tidak ditemukan dalam token
              print('User ID not found in token');
            }
          } else {
            // Token tidak ditemukan di penyimpanan
            print('Token not found in storage');
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
          print('Token found');
        }
      } else {
        // Login failed
        var errorMessage = 'Failed to login account';

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 228, 171, 0),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 35,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(0),
          ),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Masuk',
              style: TextStyle(
                  fontSize: 20, color: Colors.black, fontFamily: 'Poppins'),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.person_2_outlined,
              color: Colors.black,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 228, 171, 0),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(70),
                      ),
                    ),
                    child: const SizedBox(
                      height: 450,
                      width: 500,
                    ),
                  ),
                  Positioned(
                    top: -20,
                    bottom: 230,
                    right: 0,
                    left: 0,
                    child: Image.asset(
                      'assets/images/landing.png',
                      height: 50,
                      width: 50,
                      // fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 150,
                    bottom: -20,
                    right: 0,
                    left: 0,
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(10.10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: Colors.red,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                    color: Colors.black, fontFamily: 'Poppins'),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(188, 209, 0, 0),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(188, 209, 0, 0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(188, 209, 0, 0),
                                  ),
                                ),
                                filled: true,
                                fillColor:
                                    Colors.white, // menentukan warna background
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 24,
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Email tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              cursorColor: Colors.red,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                    color: Colors.black, fontFamily: 'Poppins'),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(188, 209, 0, 0),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(188, 209, 0, 0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(188, 209, 0, 0),
                                  ),
                                ),
                                filled: true,
                                fillColor:
                                    Colors.white, // menentukan warna background
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 24,
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () {
                                print(_emailController.text);
                                print(_passwordController.text);
                                login(context);
                              },
                              child: const Text(
                                'Masuk',
                                style: TextStyle(fontFamily: 'Poppins'),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 24),
                                minimumSize: const Size(300, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                backgroundColor:
                                    const Color.fromARGB(188, 209, 0, 0),
                                fixedSize:
                                    const Size(300, 50), // tambahkan fixedSize
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 100),
              const Text(
                'OLSELLER ',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
