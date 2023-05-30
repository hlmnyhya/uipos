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
import 'package:uipos2/transaction/print.dart';
import 'dart:convert';
import '../cappbar.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<dynamic> detailtransactionData = [];
  int? idtransaksi;
  int? idcustomer;
  Map<String, dynamic>? product;
  num totalPrice = 0; // Updated totalPrice variable

  @override
  void initState() {
    super.initState();
    fetchdetailtrans();
  }

  Future<void> fetchdetailtrans() async {
    var url = Uri.parse('http://192.168.1.8:3000/detailtransaksi');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      setState(() {
        detailtransactionData = data['data'];
        idtransaksi = detailtransactionData[0]['id_transaksi'];
        idcustomer = detailtransactionData[0]['id_customer'];

        // Calculate total price
        totalPrice = detailtransactionData.fold<num>(
          0,
          (total, product) => total + product['harga'] * product['qty'],
        );
      });
    }
  }

  String formatTotalPrice() {
    final formattedPrice =
        totalPrice.toStringAsFixed(2); // Specify decimal precision as needed
    return double.parse(formattedPrice).toString();
  }

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
        MaterialPageRoute(builder: (context) => TransactionScreen()),
      );
    }
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AccountScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Order',
        breadcrumbItem: 'Order',
        breadcrumbItem2: 'Payment',
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Center(
                        child: Container(
                          child: Icon(
                            Icons.print,
                            size: 70,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Invoice: INV/$idtransaksi/$idcustomer/${DateFormat("ddMMyy").format(DateTime.now())}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      'Cashier: Admin',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.all(10),
                      width: 400,
                      child: DataTable(
                        columns: [
                          DataColumn(
                            label: Text(
                              'Name',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Qty',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Price',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                        rows: detailtransactionData.map<DataRow>((product) {
                          final name = product['nama'];
                          final qty = product['qty'];
                          final price = product['harga'];

                          print('Name: $name, Qty: $qty, Price: $price');

                          return DataRow(cells: [
                            DataCell(Text(name)),
                            DataCell(Text('${qty}x')),
                            DataCell(Text(price.toString())),
                          ]);
                        }).toList()
                          ..add(
                            DataRow(
                              cells: [
                                DataCell(Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                )),
                                DataCell(Text('')),
                                DataCell(Text(totalPrice
                                    .toString())), // Display total price
                              ],
                            ),
                          ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Print()),
                  );
                },
                child:
                    // Icon(Icons.print),
                    //make iocn and text in a row
                    Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.print),
                    SizedBox(width: 5),
                    Text(
                      'Print',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  minimumSize: Size(150, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  backgroundColor: Color.fromARGB(188, 209, 0, 0),
                  fixedSize: Size(150, 50),
                ),
              ),
            ],
          ),
        ),
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
        onTap: _onItemTapped,
      ),
    );
  }
}
