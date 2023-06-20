import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:uipos2/signin_screen.dart';
import 'package:uipos2/landing_page.dart';
import 'package:uipos2/signup_screen.dart';
import 'package:uipos2/theme/cappbar.dart';
import 'package:uipos2/mainmenu/home_screen.dart';
import 'package:uipos2/mainmenu/menu_screen.dart';
import 'package:uipos2/mainmenu/payment_screen.dart';
import 'package:uipos2/mainmenu/order_screen.dart';
import 'package:uipos2/mainmenu/account_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../order/order_detail_screen.dart';
import 'package:uipos2/theme/bottomnavbar.dart';

class OrderSelesaiScreen extends StatefulWidget {
  const OrderSelesaiScreen({Key? key}) : super(key: key);

  @override
  State<OrderSelesaiScreen> createState() => _OrderSelesaiScreenState();
}

class _OrderSelesaiScreenState extends State<OrderSelesaiScreen> {
  String _formatDate(DateTime dateTime) {
    final formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    return formattedDate;
  }

  Future<List<dynamic>> _fetchdatatemptrans() async {
    var result = await http
        .get(Uri.parse('https://api.couplemoment.com/transaksi/trans/selesai'));
    var jsonData = json.decode(result.body);
    List<dynamic> dataList = jsonData['data'];

    // Iterate over the dataList and modify the necessary fields
    for (var data in dataList) {
      data['id_transaksi'] = data['id_transaksi'].toString();
      data['id_customer'] = data['id_customer'].toString();
      data['total'] = data['total'].toString();
      data['bayar'] = data['bayar'].toString();
      data['kembali'] = data['kembali'].toString();
      data['status'] = data['status'].toString();
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
        title: 'Pesan',
        breadcrumbItem: 'Pesan',
        breadcrumbItem2: 'Pesanan Selesai',
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
                      int order = index + 1; // Calculate the order number

                      return GestureDetector(
                        onTap: () {
                          int idTransaksi =
                              int.parse(temptrans['id_transaksi']);

                          // Replace 'orders' with your list name
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailScreen(
                                idtransaksi: idTransaksi,
                              ),
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
                                color: temptrans['status'] == 'Selesai'
                                    ? Colors.grey[300]
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      if (temptrans['status'] == 'Selesai')
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        )
                                      else if (temptrans['status'] ==
                                          'Belum Selesai')
                                        Icon(
                                          Icons.pending,
                                          color: Colors.orange,
                                        )
                                      else if (temptrans['status'] == 'Batal')
                                        Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                        ),
                                      Text(
                                        'Order #' + order.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    'Invoice: CST/' +
                                        '${temptrans['id_transaksi']}/' +
                                        '${_formatDate(temptrans['createdAt'])}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    'Tanggal: ${_formatDate(temptrans['createdAt'])}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Text(
                                    'Status: ${temptrans['status']}',
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
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
