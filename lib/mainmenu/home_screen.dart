import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uipos2/theme/cappbar.dart';
import 'package:uipos2/theme/bottomnavbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:uipos2/mainmenu/beranda/favourite_screen.dart';
import 'package:uipos2/mainmenu/menu_screen.dart';
import 'package:uipos2/mainmenu/payment_screen.dart';
import 'package:uipos2/mainmenu/order_screen.dart';
import 'package:uipos2/mainmenu/account_screen.dart';
import 'package:uipos2/order/order_pending_screen.dart';
import 'package:uipos2/order/order_selesai_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> fetchTransactionData() async {
    var url = Uri.parse('https://api.couplemoment.com/transaksi/');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
    }
  }

  void initState() {
    super.initState();
    fetchTransactionData();
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController _storeController = TextEditingController();

  void addStore(String storeName) async {
    final url = Uri.parse('https://api.couplemoment.com/store/add');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'storeName': storeName});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // Berhasil mengirim permintaan
      print('Store added successfully!');
    } else {
      // Gagal mengirim permintaan
      print('Failed to add store. Error: ${response.statusCode}');
    }
  }

  int _selectedIndex = 0;

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
        title: 'Beranda',
        breadcrumbItem: 'Beranda',
        breadcrumbItem2: 'Utama',
      ),
      body: SingleChildScrollView(
        // Wrap the existing Column with SingleChildScrollView
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Selamat Datang di Olseller!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '"Rekan bisnis Anda yang selalu siap melayani"',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: 150,
                aspectRatio: 16 / 9,
                viewportFraction:
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? 0.5 // Set viewportFraction to 0.5 for landscape mode
                        : 1.0, // Set viewportFraction to 1.0 for portrait mode
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {},
                scrollDirection: Axis.horizontal,
              ),
              items: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Image.asset('assets/images/c1.png'),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Image.asset('assets/images/c2.png'),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Image.asset('assets/images/c3.png'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            GridView.count(
              shrinkWrap: true, // Added to make GridView scrollable
              physics:
                  NeverScrollableScrollPhysics(), // Added to disable GridView's scrolling
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              padding: EdgeInsets.all(20),
              children: <Widget>[
                _buildMenuItem(
                  CupertinoIcons.graph_square_fill,
                  'Beranda',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  containerColor: Colors.white,
                  iconColor: Color.fromARGB(188, 209, 0, 0),
                  textColor: Color.fromARGB(188, 209, 0, 0),
                ),
                _buildMenuItem(
                  Icons.menu,
                  'Produk',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MenuScreen()),
                    );
                  },
                  containerColor: Colors.white,
                  iconColor: Color.fromARGB(255, 228, 171, 0),
                  textColor: Color.fromARGB(255, 228, 171, 0),
                ),
                _buildMenuItem(
                  CupertinoIcons.timer_fill,
                  'Riwayat',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderSelesaiScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  CupertinoIcons.cart_fill,
                  'Keranjang',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderPendingScreen()),
                    );
                  },
                  containerColor: Colors.white,
                  iconColor: Color.fromARGB(255, 228, 171, 0),
                  textColor: Color.fromARGB(255, 228, 171, 0),
                ),
                _buildMenuItem(
                  CupertinoIcons.star,
                  'Favorit',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FavScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  CupertinoIcons.question,
                  'Bantuan',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  containerColor: Colors.white,
                  iconColor: Color.fromARGB(255, 228, 171, 0),
                  textColor: Color.fromARGB(255, 228, 171, 0),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String storeName = '';

              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: Text(
                  'Add Store Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
                content: TextFormField(
                  controller: _storeController,
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.red,
                  decoration: InputDecoration(
                    labelText: 'Store Name',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your store name';
                    }
                    return null;
                  },
                ),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          primary: Color.fromARGB(188, 209, 0, 0),
                          padding: EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 24,
                          ),
                          minimumSize: Size(4, 4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cancel,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          addStore(storeName);
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MenuScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          primary: Color.fromARGB(188, 209, 0, 0),
                          padding: EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 24,
                          ),
                          minimumSize: Size(4, 4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.save,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
        child: Icon(CupertinoIcons.add, color: Colors.white, size: 30),
        backgroundColor: Color.fromARGB(188, 209, 0, 0),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

Widget _buildMenuItem(
  IconData icon,
  String text, {
  required Function onTap,
  Color? containerColor,
  Color? iconColor,
  Color? textColor,
}) {
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: containerColor ?? Color.fromARGB(255, 255, 255, 255),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(109, 255, 255, 255).withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 35,
            color: iconColor ?? Color.fromARGB(188, 209, 0, 0),
          ),
          SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: textColor ?? Color.fromARGB(188, 209, 0, 0),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    ),
  );
}
