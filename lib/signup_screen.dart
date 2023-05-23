import 'package:flutter/material.dart';
import 'package:uipos2/mainmenu/home_screen.dart';
import 'package:uipos2/landing_page.dart';
import 'package:uipos2/signin_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
              'Sign Up!',
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
      body: Center(
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
                            decoration: InputDecoration(
                              labelText: 'Full Name',
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
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
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
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _usernameController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Username',
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
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
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
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 25),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Aksi saat tombol "Sign In" ditekan
                                String email = _emailController.text;
                                String password = _passwordController.text;
                                print('Email: $email');
                                print('Password: $password');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomeScreen()),
                                );
                              }
                            },
                            child: const Text('Sign Up',
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
            const SizedBox(height: 20),
            const Text(
              'OLSELLER ',
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
            ),
          ],
        ),
      ),
    );
  }
}
