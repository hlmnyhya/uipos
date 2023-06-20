import 'package:flutter/cupertino.dart';
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
import 'package:uipos2/transaction/print.dart';
import 'package:uipos2/transaction/transaction_screen.dart';
import 'dart:convert';
import '../theme/cappbar.dart';
import 'package:uipos2/mainmenu/snap_screen.dart';
import 'package:uipos2/theme/bottomnavbar.dart';

class OrderDetailScreen extends StatefulWidget {
  final int idtransaksi;

  const OrderDetailScreen({
    Key? key,
    required this.idtransaksi,
  }) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int? idtemptrans;
  int? qty = 0;
  int? harga = 0;
  int? stok = 0;
  String? id_customer = "";
  String? createdAt;
  String? nama = "";
  String? kode_customer = "";

  String _formatDate(DateTime dateTime) {
    final formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    return formattedDate;
  }

  List<dynamic> transactionData = [];

  @override
  void initState() {
    super.initState();
    fetchTransactionData();
  }

  Future<void> fetchTransactionData() async {
    var url = Uri.parse(
        'https://api.couplemoment.com/temptransaksi/${widget.idtransaksi}');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      setState(() {
        transactionData = data['data'];

        print(transactionData);
      });
    }
  }

  void goToPrintScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TransactionScreen(idtransaksi: widget.idtransaksi),
      ),
    );
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrderScreen()),
      );
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
    int order = 1;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Pesan',
        breadcrumbItem: 'Pesan',
        breadcrumbItem2: 'Detail Pesanan',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 6.0),
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
                              'Order #' + order.toString(),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'Invoice: ${widget.idtransaksi.toString()}/${DateFormat('dd/mm/yyyy').format(DateTime.now())}',
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'Tanggal: ${DateFormat('dd/mm/yyyy').format(DateTime.now())}',
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
              SizedBox(
                height: 20.0,
              ),
              if (transactionData.isEmpty && transactionData.length == 0)
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Keranjang Kosong',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (transactionData.isNotEmpty && transactionData.length > 0)
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
                      int id_transaksi = transaction['id_transaksi'];
                      int quantity = transaction['qty'];
                      String? gambar = transaction['gambar'];
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
                                // '$gambar' ??
                                'https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg',
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
                                    onPressed: () async {
                                      // Make a DELETE request to the API
                                      final response = await http.delete(
                                        Uri.parse(
                                            'https://api.couplemoment.com/temptransaksi/${transaction['id_temp_trans']}'),
                                      );

                                      // Check if the request was successful
                                      if (response.statusCode == 200) {
                                        // Update the UI or perform any other necessary actions
                                        setState(() {
                                          // Remove the deleted transaction from the list
                                          transactionData.removeAt(index);
                                        });
                                      } else {
                                        // Handle the error case
                                        print(
                                            'Failed to delete the transaction.');
                                      }
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
              if (transactionData.isNotEmpty && transactionData.length > 0)
                Row(
                  children: [
                    Expanded(
                      child: DataTable(
                        columns: <DataColumn>[
                          DataColumn(
                            label: Text(
                              "Nama",
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
                              "Harga",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Total",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                        rows: [
                          ...transactionData.map<DataRow>((transaction) {
                            int quantity = transaction['qty'];
                            String productName =
                                transaction['nama'] ?? 'Unknown';
                            int price = transaction['harga'];
                            int totalProduct = quantity * price;

                            return DataRow(
                              cells: <DataCell>[
                                DataCell(Text('$productName',
                                    style: TextStyle(fontFamily: 'Poppins'))),
                                DataCell(Text('$quantity',
                                    style: TextStyle(fontFamily: 'Poppins'))),
                                DataCell(Text('$price',
                                    style: TextStyle(fontFamily: 'Poppins'))),
                                DataCell(Text('$totalProduct',
                                    style: TextStyle(fontFamily: 'Poppins'))),
                              ],
                            );
                          }),
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text('Total',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins'))),
                              DataCell(Text('')),
                              DataCell(Text('')),
                              DataCell(Text(
                                '${transactionData.fold(0, (sum, transaction) => sum + (transaction['harga'] as num).toInt() * (transaction['qty'] as num).toInt()).toInt()}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins'),
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 20.0),
              // if (transactionData.isNotEmpty && transactionData.length > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final response = await http.delete(
                        Uri.parse(
                            'https://api.couplemoment.com/temptransaksi/deleteall/${widget.idtransaksi}'),
                      );

                      if (response.statusCode == 200) {
                        // Show a SnackBar with a success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Transaction canceled.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // Update the UI or perform any other necessary actions
                        // ...
                      } else {
                        // Show a SnackBar with an error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to cancel transaction.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        // Handle the error case
                        print('Failed to delete data from temp_trans.');
                      }
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
                      'Batal',
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
                              'Metode Pembayaran',
                              style: TextStyle(
                                fontSize: 16,
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
                                      goToPrintScreen();
                                      // Add cash payment logic here
                                      Navigator.pop(context);

                                      var apiUrl = Uri.parse(
                                          'https://api.couplemoment.com/detailtransaksi/add');
                                      var requestBody = {
                                        // Provide the required data for the API call
                                        // Example: 'key': 'value'
                                      };
                                      var response = await http.post(apiUrl,
                                          body: requestBody);

                                      if (response.statusCode == 200) {
                                        // Show a SnackBar with a success message
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Transaction has been checkout.'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        // Update the UI or perform any other necessary actions
                                        // ...
                                      } else {
                                        // Show a SnackBar with an error message
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Failed to checkout transaction.'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        // Handle the error case
                                        print(
                                            'Failed to delete data from temp_trans.');
                                      }
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TransactionScreen(
                                                  idtransaksi:
                                                      widget.idtransaksi),
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
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.monetization_on,
                                          color: Colors.white,
                                          size: 18.0,
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          'Tunai',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Poppins',
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MidtransSnapScreen(
                                                    idtransaksi:
                                                        widget.idtransaksi,
                                                  )));
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
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.smartphone,
                                          color: Colors.white,
                                          size: 18.0,
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          'Online',
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
                      'Bayar',
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
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
