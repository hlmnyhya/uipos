import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uipos2/signin_screen.dart';
import 'package:uipos2/landing_page.dart';
import 'package:uipos2/signup_screen.dart';
import 'package:uipos2/cappbar.dart';
import 'package:uipos2/mainmenu/home_screen.dart';
import 'package:uipos2/mainmenu/menu_screen.dart';
import 'package:uipos2/mainmenu/payment_screen.dart';
import 'package:uipos2/mainmenu/order_screen.dart';
import 'package:uipos2/mainmenu/account_screen.dart';
import 'package:uipos2/menu/menu_add_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<dynamic> menuItems = []; // List to store the menu items

  Future<List<dynamic>> _fetchdataproduct() async {
    final url = Uri.parse('https://api.couplemoment.com/product');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        menuItems = jsonData['menu'];
      });
      return menuItems;
    } else {
      print('Failed to fetch menu. Error: ${response.statusCode}');
      return []; // Return an empty list in case of error or unsuccessful response
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchdataproduct(); // Fetch the menu items when the screen is initialized
  }

  // void navigateToDetailScreen(dynamic product) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => DetailScreen(product: product)),
  //   );
  // }

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 0) {
      // Navigasi ke HomeScreen
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
        title: 'Menu',
        breadcrumbItem: 'Menu',
        breadcrumbItem2: 'All Menu',
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _fetchdataproduct(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20, // Horizontal spacing between columns
                    mainAxisSpacing: 20, // Vertical spacing between columns
                    padding: EdgeInsets.all(20),
                    children: List.generate(snapshot.data.length, (index) {
                      final product = snapshot.data[index];
                      return GestureDetector(
                        // onTap: () => _addToCart(product),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 255, 255, 255)
                                    .withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    'https://reqres.in/img/faces/7-image.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['nama'],
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 35, 35, 35),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    Text(
                                      product['deskripsi'],
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 35, 35, 35),
                                        fontSize: 10,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Rp. ${product['harga']},-',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 35, 35, 35),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Stok : ${product['stok']}',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 35, 35, 35),
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(188, 209, 0, 0),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // Tambahkan kode aksi untuk tombol shopping cart_checkout di sini
            },
            child: Icon(Icons.shopping_cart_checkout),
            backgroundColor: Color.fromARGB(255, 228, 171, 0),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuScreenAdd()),
              );
            },
            child: Icon(Icons.add),
            backgroundColor: Color.fromARGB(188, 209, 0, 0),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: Color.fromARGB(188, 209, 0, 0),
              radius: 30,
              child: Icon(Icons.qr_code, color: Colors.white, size: 30),
            ),
            label: 'Payment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(188, 209, 0, 0),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedFontSize: 13.0,
        unselectedFontSize: 13.0,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
        ),
        onTap: _onItemTapped,
      ),
    );
  }
}
