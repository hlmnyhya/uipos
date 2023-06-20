import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final String? hintText;

  const CustomInputField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      cursorColor: Colors.red,
      decoration: InputDecoration(
        labelText: labelText,
        prefix: labelText == 'Harga Produk' ? Text('Rp. ') : null,
        hintText: hintText,
        labelStyle: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
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
      validator: validator,
    );
  }
}
