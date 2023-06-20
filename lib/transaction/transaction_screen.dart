import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uipos2/mainmenu/home_screen.dart';
import 'package:uipos2/mainmenu/menu_screen.dart';
import 'package:uipos2/mainmenu/payment_screen.dart';
import 'package:uipos2/mainmenu/account_screen.dart';
import 'package:http/http.dart' as http;
import 'package:uipos2/transaction/print.dart';
import 'dart:convert';
import 'package:uipos2/theme/cappbar.dart';
import 'package:uipos2/theme/bottomnavbar.dart';

class TransactionScreen extends StatefulWidget {
  final int idtransaksi;

  const TransactionScreen({Key? key, required this.idtransaksi})
      : super(key: key);

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
    idtransaksi = widget.idtransaksi;
    fetchdetailtrans();
  }

  Future<void> fetchdetailtrans() async {
    var url = Uri.parse(
        'https://api.couplemoment.com/detailtransaksi/${widget.idtransaksi}');
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
        MaterialPageRoute(
            builder: (context) => TransactionScreen(
                  idtransaksi: widget.idtransaksi,
                )),
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
        title: 'Pesan',
        breadcrumbItem: 'Pesan',
        breadcrumbItem2: 'Pembayaran',
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
                      'Invoice: CST/' +
                          '${DateFormat("dd/MM/yyyy").format(DateTime.now())}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      'Kasir: Admin',
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
                              'Nama',
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
                              'Harga',
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
                    MaterialPageRoute(
                        builder: (context) => Print(
                              idtransaksi: widget.idtransaksi,
                            )),
                  );
                },
                child:
                    // Icon(Icons.print),
                    //make iocn and text in a row
                    Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.print, size: 15),
                    SizedBox(width: 5),
                    Text(
                      'Cetak Struk',
                      style: TextStyle(
                        fontSize: 14,
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
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
