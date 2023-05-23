import 'package:flutter/material.dart';
import 'package:uipos2/cappbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uipos2/mainmenu/home_screen.dart';
import 'package:uipos2/mainmenu/menu_screen.dart';
import 'package:uipos2/mainmenu/payment_screen.dart';
import 'package:uipos2/mainmenu/order_screen.dart';
import 'package:uipos2/mainmenu/account_screen.dart';
import 'package:uipos2/transaction/transaction_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  final int idTempTrans;

  const OrderDetailScreen({super.key, required this.idTempTrans});

  @override
  // ignore: library_private_types_in_public_api
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
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
    fetchData();
  }

  Future<void> fetchData() async {
    const apiUrl = "http://localhost:3000/temptransaksi/1";
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
        productList = tempTransData[
            'products']; // Perbarui productList dengan data produk
      });
    }
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
        breadcrumbItem2: 'Order Detail',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.grey[300],
                elevation: 2.0,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #${widget.idTempTrans}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            'Invoice: ${invoice?.toString() ?? ''}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            'Quantity: ${qty?.toString() ?? ''}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            'Date: ${date != null ? DateTime.parse(date!).toString() : ''}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.print,
                          size: 40,
                        ),
                        onPressed: () {
                          // Add print logic here
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              elevation: 2.0,
              child: ListTile(
                title: Text(
                  'Nama: ${nama ?? ''}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Harga: Rp. ${harga?.toString() ?? ''},-',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      'Stok: ${stok?.toString() ?? ''}',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              elevation: 2.0,
              child: ListTile(
                title: Text(
                  'Additional Information',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Some additional information about the order.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add cancel logic here
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    minimumSize: Size(150, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    backgroundColor: Color.fromARGB(255, 228, 171, 0),
                    fixedSize: Size(150, 50),
                  ),
                  child: Text('Cancel',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 14.0)),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          title: Text(
                            'Select Payment Method',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          content: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Add cash payment logic here
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TransactionScreen(),
                                      ),
                                    ); // Close the dialog
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    primary: Color.fromARGB(188, 209, 0, 0),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 24),
                                    minimumSize: Size(200, 50),
                                  ),
                                  child: Text(
                                    'Cash',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                ElevatedButton(
                                  onPressed: () {
                                    // Add online payment logic here
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    primary: Color.fromARGB(188, 209, 0, 0),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 24),
                                    minimumSize: Size(200, 50),
                                  ),
                                  child: Text(
                                    'Online Payment',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    minimumSize: Size(150, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    backgroundColor: Color.fromARGB(188, 209, 0, 0),
                    fixedSize: Size(150, 50),
                  ),
                  child: Text(
                    'Checkout',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
