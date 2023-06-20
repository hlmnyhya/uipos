import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uipos2/landing_page.dart';
import 'dart:convert';
import 'package:uipos2/signin_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final storage = FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;

      Map<String, dynamic> requestBody = {
        'name': name,
        'email': email,
        'password': password,
      };

      var url = Uri.parse('https://couplemoment.com/user/register');
      var response = await http.post(url, body: requestBody);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Account registered successfully'),
              backgroundColor: Colors.green),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
        var responseData = json.decode(response.body);
        String token = responseData['token'];

        // Store the token securely
        await storage.write(key: 'token', value: token);
      } else {
        // Registration failed
        var errorMessage = 'Gagal membuat akun';
        // Handle the error message here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LandingPage()),
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
              'Daftar',
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
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(10.10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _nameController,
                              keyboardType: TextInputType.text,
                              cursorColor: Colors.red,
                              decoration: InputDecoration(
                                labelText: 'Nama',
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
                                if (value == null || value.isEmpty) {
                                  return 'Nama tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
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

                            const SizedBox(height: 10),
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
                            const SizedBox(height: 25),
                            ElevatedButton(
                              onPressed: () {
                                print(_nameController.text);
                                print(_emailController.text);
                                print(_passwordController.text);
                                register();
                              },
                              child: const Text('Daftar',
                                  style: TextStyle(fontFamily: 'Poppins')),
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
                            // const SizedBox(height: 50),
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
              SizedBox(height: 50),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                  );
                },
                child: Text(
                  'Sudah punya akun? Masuk',
                  style: TextStyle(fontFamily: 'Poppins', color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
