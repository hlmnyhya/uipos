import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:uipos2/signin_screen.dart';
import 'package:uipos2/landing_page.dart';
import 'package:uipos2/signup_screen.dart';
import 'package:uipos2/cappbar.dart';
import 'package:uipos2/mainmenu/home_screen.dart';
import 'package:uipos2/mainmenu/menu_screen.dart';
import 'package:uipos2/mainmenu/payment_screen.dart';
import 'package:uipos2/mainmenu/order_screen.dart';
import 'package:uipos2/mainmenu/account_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import '../order/order_detail_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future<List<dynamic>> _fetchdatatemptrans() async {
    var result =
        await http.get(Uri.parse('http://192.168.1.8:3000/temptransaksi'));
    var jsonData = json.decode(result.body);
    List<dynamic> dataList = jsonData['data'];

    // Iterate over the dataList and modify the necessary fields
    for (var data in dataList) {
      data['id_transaksi'] = data['id_transaksi'].toString();
      data['id_customer'] = data['id_customer'].toString();
      data['total'] = data['total'].toString();
      data['bayar'] = data['bayar'].toString();
      data['kembali'] = data['kembali'].toString();
      data['createdAt'] = DateTime.parse(data['createdAt']);
      data['updatedAt'] = DateTime.parse(data['updatedAt']);
    }

    return dataList;
  }

  Future<Widget> get child async => GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          // your grid view items
        ],
      );

  int _selectedIndex = 3;

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
        title: 'Order',
        breadcrumbItem: 'Order',
        breadcrumbItem2: 'Order All',
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchdatatemptrans(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    reverse: false,
                    itemBuilder: (BuildContext context, int index) {
                      final temptrans = snapshot.data[index];
                      return GestureDetector(
                        onTap: () {
                          // int idTransaksi = temptrans['id_transaksi'];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailScreen(
                                  idtransaksi:
                                      1), // Replace 123 with your actual idtransaksi value
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 20),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 20.0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order #${temptrans['id_transaksi']}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    'Invoice: INV/${temptrans['id_transaksi']}/${DateFormat('ddmmyy').format(DateTime.now())}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    'Date: ${temptrans['createdAt']}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(188, 209, 0, 0),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // tetap tampil sejumlah item
        showSelectedLabels: true,
        // menyembunyikan label yang dipilih
        // showUnselectedLabels: false, // menyembunyikan label yang tidak dipilih
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
