import 'package:flutter/material.dart';
import 'package:uipos2/bluetooth_screen.dart';
import 'package:uipos2/cappbar.dart';
import 'package:uipos2/mainmenu/home_screen.dart';
import 'package:uipos2/mainmenu/menu_screen.dart';
import 'package:uipos2/mainmenu/payment_screen.dart';
import 'package:uipos2/mainmenu/order_screen.dart';
import 'package:uipos2/mainmenu/account_screen.dart';
import 'package:uipos2/mainmenu/edit_account_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  Object? get idTempTrans => null;
  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  int? qty;
  int? harga;
  int? stok;
  String? invoice;
  String? date;
  String? nama;

  List<dynamic> productList = [];

  @override
  void initState() {
    super.initState();
    fetchDataTransaksi();
  }

  Future<List<dynamic>> fetchDataTransaksi() async {
    const apiUrl = "http://localhost:3000/transaksi/1";
    final response = await http.get(Uri.parse(apiUrl));
    final data = json.decode(response.body);

    final List<dynamic> tempTransDataList = data['data'];
    final tempTransData = tempTransDataList.firstWhere(
      (tempTrans) => tempTrans['id_temp_trans'] == widget.idTempTrans,
      orElse: () => null,
    );

    if (tempTransData != null) {
      setState(() {
        invoice = tempTransData['invoice'].toString();
        qty = tempTransData['qty'];
        date = tempTransData['date'];
        productList = tempTransData['products'];
      });
    }

    return productList; // Return the productList as a List<dynamic>
  }

  int _selectedIndex = 3;

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
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                      'ID Customer: 123/21321/213',
                      style: TextStyle(
                        fontSize: 14,
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
                        rows: [
                          DataRow(cells: [
                            DataCell(Text('Sweet Sugar Caramel')),
                            DataCell(Text('1x')),
                            DataCell(Text(15000.toInt().toString())),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('Coffee Latte')),
                            DataCell(Text('1x')),
                            DataCell(Text(15000.toInt().toString())),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('Coffee Latte')),
                            DataCell(Text('1x')),
                            DataCell(Text(15000.toInt().toString())),
                          ]),
                          DataRow(cells: [
                            DataCell(
                              Text('Total',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            DataCell(Text('')),
                            DataCell(Text(15000.toInt().toString())),
                          ]),
                          DataRow(cells: [
                            DataCell(
                              Text('Bayar',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            DataCell(Text('')),
                            DataCell(Text(15000.toInt().toString())),
                          ]),
                          DataRow(cells: [
                            DataCell(
                              Text('Kembali',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            DataCell(Text('')),
                            DataCell(Text(15000.toInt().toString())),
                          ]),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Add your onPressed logic here
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        primary: Color.fromARGB(188, 209, 0, 0),
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        minimumSize: Size(150, 40),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.print,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Print Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
