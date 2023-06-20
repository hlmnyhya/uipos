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
import 'package:charts_flutter/flutter.dart' as charts;

class FavoriteProduct {
  final String nama;
  final int totalCount;

  FavoriteProduct(this.nama, this.totalCount);
}

class TotalSell {
  final int totaltransaksi;

  TotalSell(this.totaltransaksi);
}

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  final storage = const FlutterSecureStorage();

  Future<List<FavoriteProduct>> fetchfavorit() async {
    var url = Uri.parse('https://api.couplemoment.com/product/count/fav');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<dynamic> favoritesData = data['data'];

      List<FavoriteProduct> favorites = favoritesData.map((favoriteData) {
        return FavoriteProduct(
          favoriteData['nama'],
          favoriteData['total_count'],
        );
      }).toList();

      return favorites;
    } else {
      throw Exception('Failed to fetch favorites');
    }
  }

  Future<List<TotalSell>> fetchtotalsell() async {
    var url = Uri.parse('https://api.couplemoment.com/transaksi/count/trans');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<dynamic> totalsellData = data['data'];

      List<TotalSell> totalsell = totalsellData.map((totalsellData) {
        return TotalSell(
          totalsellData['total_transaksi'],
        );
      }).toList();

      return totalsell;
    } else {
      throw Exception('Gagal mengambil data total transaksi');
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
        breadcrumbItem2: 'Favorit',
      ),
      body: SingleChildScrollView(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            children: [
              Text(
                'Produk Favorit',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(
                height: 300,
                child: FutureBuilder<List<FavoriteProduct>>(
                  future: fetchfavorit(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      List<FavoriteProduct> favorites = snapshot.data!;
                      if (favorites.isEmpty) {
                        return Center(
                          child: Text(
                            'Tidak ada data yang ditampilkan',
                            style:
                                TextStyle(fontSize: 12, fontFamily: 'Poppins'),
                          ),
                        );
                      } else {
                        // Display the bar chart with data
                        List<charts.Series<FavoriteProduct, String>> series = [
                          charts.Series(
                            id: 'Favorites',
                            data: favorites,
                            domainFn: (FavoriteProduct favorite, _) =>
                                favorite.nama,
                            measureFn: (FavoriteProduct favorite, _) =>
                                favorite.totalCount,
                            colorFn: (_, __) =>
                                charts.MaterialPalette.red.shadeDefault,
                          ),
                        ];

                        return DefaultTextStyle(
                          style: TextStyle(
                            fontFamily: 'Poppins',
                          ),
                          child: charts.BarChart(
                            series,
                            animate: true,
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  Text(
                    'Total Transaksi',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: FutureBuilder<List<TotalSell>>(
                      future: fetchtotalsell(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.red,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          List<TotalSell> totalsell = snapshot.data!;
                          if (totalsell.isEmpty) {
                            return Center(
                              child: Text(
                                'Tidak ada data yang ditampilkan',
                                style: TextStyle(
                                    fontSize: 12, fontFamily: 'Poppins'),
                              ),
                            );
                          } else {
                            // Display the bar chart with data
                            List<charts.Series<TotalSell, String>> series = [
                              charts.Series(
                                id: 'Total Transaksi',
                                data: totalsell,
                                domainFn: (TotalSell totalsell, _) =>
                                    'Total Transaksi',
                                measureFn: (TotalSell totalsell, _) =>
                                    totalsell.totaltransaksi,
                                colorFn: (_, __) =>
                                    charts.MaterialPalette.yellow.shadeDefault,
                              ),
                            ];

                            return DefaultTextStyle(
                              style: TextStyle(
                                fontFamily: 'Poppins',
                              ),
                              child: charts.BarChart(
                                series,
                                animate: true,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
              child: Icon(CupertinoIcons.qrcode, color: Colors.white, size: 30),
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
