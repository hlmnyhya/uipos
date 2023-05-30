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
import 'dart:convert';
import '../cappbar.dart';

class OrderDetailScreen extends StatefulWidget {
  final int idtransaksi;

  const OrderDetailScreen({Key? key, required this.idtransaksi})
      : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int? qty = 0;
  int? harga = 0;
  int? stok = 0;
  String? id_customer = "";
  String? createdAt = "";
  String? nama = "";

  List<dynamic> transactionData = [];

  @override
  void initState() {
    super.initState();
    fetchTransactionData();
  }

  Future<void> fetchTransactionData() async {
    var url = Uri.parse('http://192.168.1.8:3000/temptransaksi');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      setState(() {
        transactionData = data['data'];
      });
    }
  }

  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MenuScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PaymentScreen()),
      );
    } else if (index == 3) {
      // No need to navigate to the same screen
      return;
    } else if (index == 4) {
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
    int? quantity;
    String? productName;
    int? price;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Order',
        breadcrumbItem: 'Order',
        breadcrumbItem2: 'Order Detail',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
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
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order #${widget.idtransaksi}',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'ID Customer: $id_customer',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12.0,
                              ),
                            ),
                            Text(
                              'Invoice: INV/${widget.idtransaksi}/${widget.idtransaksi + 1}/${DateFormat("ddMMyy").format(DateTime.now())}',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              'Date: $createdAt',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12.0,
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
              Container(
                width: 400,
                height: 200,
                padding: EdgeInsets.all(10.0),
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 15.0,
                  ),
                  itemCount: transactionData.length,
                  itemBuilder: (context, index) {
                    var transaction = transactionData[index];
                    int quantity = transaction['qty'];
                    String productName = transaction['nama'] ?? 'Unknown';
                    int price = transaction['harga'];
                    int totalProduct = quantity * price;

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              'https://reqres.in/img/faces/7-image.jpg',
                              fit: BoxFit.cover,
                              width: 200,
                              height: 50,
                            ),
                            Text(
                              '$productName',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Qty: $quantity',
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                            Text(
                              'Harga: Rp. $totalProduct,-',
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (quantity > 0) {
                                        quantity--;
                                      }
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(5.0),
                                    primary: Colors.red,
                                  ),
                                  child: Icon(
                                    Icons.delete,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: DataTable(
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text(
                            "Product",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "Qty",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "Price",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      rows: <DataRow>[
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Caramel Macchiato')),
                            DataCell(Text('3')),
                            DataCell(Text('90000')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Babu')),
                            DataCell(Text('1')),
                            DataCell(Text('12000')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
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
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      minimumSize: Size(150, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      backgroundColor: Color.fromARGB(255, 228, 171, 0),
                      fixedSize: Size(150, 50),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 14.0,
                      ),
                    ),
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
                                    onPressed: () async {
                                      // Add cash payment logic here
                                      Navigator.pop(context);

                                      var apiUrl = Uri.parse(
                                          'http://192.168.1.8:3000/detailtransaksi/add');
                                      var requestBody = {
                                        // Provide the required data for the API call
                                        // Example: 'key': 'value'
                                      };
                                      var response = await http.post(apiUrl,
                                          body: requestBody);

                                      if (response.statusCode == 200) {
                                        // Successful API call, handle the response
                                        print(response.body);
                                        // Add your desired logic here
                                      } else {
                                        // Error occurred during the API call
                                        // Handle the error
                                      }
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TransactionScreen(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
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
                                    onPressed: () async {
                                      // Add cash payment logic here
                                      Navigator.pop(context);

                                      var apiUrl = Uri.parse(
                                          'http://192.168.1.8:3000/detailtransaksi/add');
                                      var requestBody = {
                                        // Provide the required data for the API call
                                        // Example: 'key': 'value'
                                      };
                                      var response = await http.post(apiUrl,
                                          body: requestBody);

                                      if (response.statusCode == 200) {
                                        // Successful API call, handle the response
                                        print(response.body);
                                        // Add your desired logic here
                                      } else {
                                        // Error occurred during the API call
                                        // Handle the error
                                      }
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TransactionScreen(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      primary: Colors.grey[400],
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
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
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
        onTap: _onItemTapped,
      ),
    );
  }
}
