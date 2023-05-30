import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uipos2/mainmenu/home_screen.dart';
import 'package:uipos2/mainmenu/menu_screen.dart';
import 'package:uipos2/menu/menu_add_screen.dart';
import 'package:uipos2/menu/menu_edit_screen.dart';
import 'package:uipos2/mainmenu/payment_screen.dart';
import 'package:uipos2/mainmenu/order_screen.dart';
import 'package:uipos2/mainmenu/account_screen.dart';
import 'package:http/http.dart' as http;
import 'package:uipos2/transaction/transaction_screen.dart';
import 'dart:convert';
import '../cappbar.dart';
// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';

class Print extends StatefulWidget {
  const Print({super.key});

  @override
  State<Print> createState() => _PrintState();
}

class _PrintState extends State<Print> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Print',
        breadcrumbItem: 'Print',
        breadcrumbItem2: 'Payment',
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Text('Print'),
        ),
      ),
    );
  }
}
