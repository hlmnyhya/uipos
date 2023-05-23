import 'package:flutter/material.dart';

class EditAccountForm extends StatefulWidget {
  @override
  _EditAccountFormState createState() => _EditAccountFormState();
}

class _EditAccountFormState extends State<EditAccountForm> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Full Name',
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
                fillColor: Colors.white, // menentukan warna background
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
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
                fillColor: Colors.white, // menentukan warna background
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
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Password',
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
                fillColor: Colors.white, // menentukan warna background
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your new password';
                }
                return null;
              },
            ),
            SizedBox(height: 3),
          ],
        ),
      ),
    );
  }
}
