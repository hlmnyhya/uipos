import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uipos2/signin_screen.dart';
import 'package:uipos2/landing_page.dart';
import 'package:uipos2/signup_screen.dart';
import 'package:uipos2/theme/cappbar.dart';
import 'package:uipos2/mainmenu/home_screen.dart';
import 'package:uipos2/mainmenu/menu_screen.dart';
import 'package:uipos2/mainmenu/payment_screen.dart';
import 'package:uipos2/mainmenu/order_screen.dart';
import 'package:uipos2/mainmenu/account_screen.dart';
import 'package:uipos2/mainmenu/edit_account_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uipos2/theme/bottomnavbar.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final storage = FlutterSecureStorage();

  Future<void> signout(BuildContext context) async {
    var url = Uri.parse('https://couplemoment.com/user/logout');
    var response = await http.post(url);

    if (response.statusCode == 200) {
      await storage.delete(key: 'token');
      Route route = MaterialPageRoute(builder: (context) => LandingPage());
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LandingPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  int _selectedIndex = 4;

  Future<Widget> get child async => GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          // your grid view items
        ],
      );

  void _onItemTapped(int index) {
    if (index == 0) {
      // Navigasi ke MenuScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MenuScreen()),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PaymentScreen()),
      );
    }
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrderScreen()),
      );
    }
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AccountScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Akun',
        breadcrumbItem: 'Profil',
        breadcrumbItem2: 'Akun',
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/Scooter.png'),
              ),
              SizedBox(height: 5),
              Text(
                'OLSELLER',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                'olseller@customer.com',
                style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
              ),
              SizedBox(height: 10),
              EditAccountForm(),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  signout(context);
                },
                child: Text(
                  'Keluar',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  minimumSize: Size(300, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: Color.fromARGB(188, 209, 0, 0),
                  fixedSize: Size(300, 50),
                ),
              ),
            ],
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
