import 'package:flutter/material.dart';
import 'package:uipos2/menu/menu_add_screen.dart';
import 'package:uipos2/shortcut/history_screen.dart';
import 'package:uipos2/cappbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:uipos2/mainmenu/home_screen.dart';
import 'package:uipos2/mainmenu/menu_screen.dart';
import 'package:uipos2/mainmenu/payment_screen.dart';
import 'package:uipos2/mainmenu/order_screen.dart';
import 'package:uipos2/mainmenu/account_screen.dart';
import 'package:uipos2/menu/menu_add_screen.dart';
import 'package:uipos2/transaction/transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        title: 'Dashboard',
        breadcrumbItem: 'Home',
        breadcrumbItem2: 'Home',
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            width: 900,
            height: 80,
            child: TextFormField(
              decoration: InputDecoration(
                  hintTextDirection: TextDirection.ltr,
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 5)),
            ),
          ),
          CarouselSlider(
            options: CarouselOptions(
              height: 150, // Tinggi carousel
              aspectRatio: 16 / 9, // Rasio aspek carousel
              viewportFraction: 1, // Fraksi viewport yang terlihat
              initialPage: 0, // Halaman awal yang ditampilkan
              enableInfiniteScroll: true, // Aktifkan scroll tak terbatas
              reverse: false, // Putar tampilan carousel secara terbalik
              autoPlay: true, // Aktifkan autoplay
              autoPlayInterval: Duration(seconds: 3), // Interval autoplay
              autoPlayAnimationDuration:
                  Duration(milliseconds: 800), // Durasi animasi autoplay
              autoPlayCurve: Curves.fastOutSlowIn, // Kurva animasi autoplay
              enlargeCenterPage: true, // Perbesar halaman tengah
              onPageChanged: (index,
                  reason) {}, // Fungsi yang dipanggil saat halaman berubah
              scrollDirection: Axis.horizontal, // Arah scroll carousel
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
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              padding: EdgeInsets.all(20),
              children: <Widget>[
                _buildMenuItem(Icons.dashboard, 'Dashboard', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                }),
                _buildMenuItem(
                  Icons.list_alt_rounded,
                  'Menu',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MenuScreen()),
                    );
                  },
                ),
                _buildMenuItem(Icons.history, 'History', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TransactionScreen()),
                  );
                }),
                _buildMenuItem(Icons.shopping_cart_rounded, 'Cart', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderScreen()),
                  );
                }),
                _buildMenuItem(Icons.favorite_border_rounded, 'Favourites',
                    onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountScreen()),
                  );
                }),
                _buildMenuItem(Icons.help_rounded, 'Help', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountScreen()),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_sharp),
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

Widget _buildMenuItem(IconData icon, String text, {required Function onTap}) {
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromARGB(255, 255, 255, 255),
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
            color: Color.fromARGB(188, 209, 0, 0),
          ),
          SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Color.fromARGB(188, 209, 0, 0),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    ),
  );
}
