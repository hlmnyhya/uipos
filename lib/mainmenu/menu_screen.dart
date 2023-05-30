import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uipos2/signin_screen.dart';
import 'package:uipos2/landing_page.dart';
import 'package:uipos2/signup_screen.dart';
import 'package:uipos2/cappbar.dart';
import 'package:uipos2/mainmenu/home_screen.dart';
import 'package:uipos2/mainmenu/menu_screen.dart';
import 'package:uipos2/mainmenu/payment_screen.dart';
import 'package:uipos2/mainmenu/order_screen.dart';
import 'package:uipos2/mainmenu/account_screen.dart';
import 'package:uipos2/menu/menu_add_screen.dart';
import 'package:uipos2/menu/menu_detail_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Map<String, dynamic>> _cartItems = [];
  int? productId;
  String? productName;
  String? productPrice;
  String? productImage;
  String? productDescription;
  String? productStock;
  Map<String, dynamic>? cartproduct;

  Future<List<Map<String, dynamic>>> _fetchdataproduct() async {
    var result = await http.get(Uri.parse('http://192.168.1.8:3000/product'));
    var data = json.decode(result.body)['data'];
    return List<Map<String, dynamic>>.from(data);
  }

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else if (index == 1) {
      // Stay on MenuScreen
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
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToDetailScreen(Map<String, dynamic> product) {
    if (product['stok'] > 0) {
      productId = product['id_product'];
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailScreen(product: product)),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(
              'Out of Stock',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            content: Text('This product is currently out of stock.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Menu',
        breadcrumbItem: 'Menu',
        breadcrumbItem2: 'All Menu',
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchdataproduct(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  return GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    padding: EdgeInsets.all(20),
                    children: List.generate(snapshot.data!.length, (index) {
                      final product = snapshot.data![index];
                      int qty = 0;

                      return GestureDetector(
                        onTap: () => _navigateToDetailScreen(product),
                        child: Stack(
                          children: [
                            buildProductCard(product, qty, context),
                          ],
                        ),
                      );
                    }),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(188, 209, 0, 0),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderScreen()),
              ); // Tambahkan kode aksi untuk tombol shopping cart_checkout di sini
            },
            child: Icon(Icons.shopping_cart_checkout),
            backgroundColor: Color.fromARGB(255, 228, 171, 0),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuScreenAdd()),
              );
            },
            child: Icon(Icons.add),
            backgroundColor: Color.fromARGB(188, 209, 0, 0),
          ),
        ],
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

Widget buildProductCard(dynamic product, int qty, BuildContext context) {
  var cartproduct;
  bool isOutOfStock = product['stok'] == 0;
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product['gambar'] ??
                      'https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(
                    product['nama'],
                    style: TextStyle(
                      color: Color.fromARGB(255, 35, 35, 35),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    product['deskripsi'],
                    style: TextStyle(
                      color: Color.fromARGB(255, 35, 35, 35),
                      fontSize: 10,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Rp. ${product['harga']},-',
                    style: TextStyle(
                      color: Color.fromARGB(255, 35, 35, 35),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    isOutOfStock ? 'Out of Stock' : 'Stok: ${product['stok']}',
                    style: TextStyle(
                      color: isOutOfStock
                          ? Colors.red
                          : Color.fromARGB(255, 35, 35, 35),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isOutOfStock)
          Positioned(
            top: 120,
            right: 6,
            child: CircleAvatar(
              backgroundColor: Colors.red,
              radius: 20,
              child: IconButton(
                onPressed: () {
                  cartproduct = product;
                  // print(cartproduct);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddToCartDialog(
                        product: product,
                        qty: qty,
                        onAddToCart: () {
                          // Add to cart logic here
                          Navigator.pop(context); // Close the dialog
                        },
                      );
                    },
                  );
                },
                icon: Icon(Icons.add, size: 15),
                color: Colors.white,
                padding: EdgeInsets.all(5),
                splashRadius: 20,
              ),
            ),
          ),
      ],
    ),
  );
}

class AddToCartDialog extends StatefulWidget {
  final dynamic product;
  final int qty;
  final String? productId;
  final Function() onAddToCart;

  const AddToCartDialog({
    required this.product,
    required this.qty,
    this.productId,
    required this.onAddToCart,
  });

  @override
  _AddToCartDialogState createState() => _AddToCartDialogState();
}

class _AddToCartDialogState extends State<AddToCartDialog> {
  late int qty;

  @override
  void initState() {
    super.initState();
    qty = widget.qty;
  }

  Future<void> _addToCart() async {
    try {
      // Create a request data object
      Map<String, dynamic> requestData = {
        'id_temp_trans': widget.product['id_temp_trans'],
        'id_product': widget.product['id_product'],
        'qty': qty,
        'nama': widget.product['nama'],
        'harga': widget.product['harga'],
      };

      // Convert requestData to JSON
      String requestDataJson = jsonEncode(requestData);

      // Print the requestData in JSON format
      print('Request Data: $requestDataJson');

      // Make an HTTP POST request to the API
      var response = await http.post(
        Uri.parse('http://192.168.1.8:3000/temptransaksi/add'),
        // Replace with the appropriate API URL
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestDataJson,
      );

      // Check the response status code
      if (response.statusCode == 200) {
        // Successfully added to temptransaksi, perform additional actions if needed
        print('Data added to temptransaksi successfully');

        // Insert data into the transaksi table
        var transaksiData = {
          'total':
              0, // Set the initial total to 0 or calculate it based on the added products
          'bayar': 0, // Set the initial bayar value to 0 or update it later
          'kembali': 0, // Set the initial kembali value to 0 or update it later
        };

        var transaksiResponse = await http.post(
          Uri.parse('http://192.168.1.8:3000/transaksi/add'),
          // Replace with the appropriate API URL
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(transaksiData),
        );

        if (transaksiResponse.statusCode == 200) {
          // Successfully added to the transaksi table
          var transaksiId =
              jsonDecode(transaksiResponse.body)['data']['id_transaksi'];
          print('Data added to transaksi successfully with ID: $transaksiId');

          // Insert data into the customer table
          var customerData = {
            'nama': '', // Set the appropriate customer name
            'kode_customer': '', // Set the appropriate customer code
          };

          var customerResponse = await http.post(
            Uri.parse('http://192.168.1.8:3000/customer/add'),
            // Replace with the appropriate API URL
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(customerData),
          );

          if (customerResponse.statusCode == 200) {
            // Successfully added to the customer table
            var customerId =
                jsonDecode(customerResponse.body)['data']['id_customer'];
            print('Data added to customer successfully with ID: $customerId');
            widget.onAddToCart(); // Call the onAddToCart function
            // Close the dialog
          } else {
            // Failed to add to the customer table, handle the error if needed
            print('Failed to add data to customer');
          }
        } else {
          // Failed to add to the transaksi table, handle the error if needed
          print('Failed to add data to transaksi');
        }
      } else {
        // Failed to add to temptransaksi, handle the error if needed
        print('Failed to add data to temptransaksi');
      }
    } catch (e) {
      // Handle connection errors or any other exceptions
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Add to Cart',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFamily: 'Poppins',
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.product['nama'],
            style: TextStyle(
              color: Color.fromARGB(255, 35, 35, 35),
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Rp. ${(widget.product['harga'] * qty).toString()},-',
            style: TextStyle(
              color: Color.fromARGB(255, 35, 35, 35),
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    if (qty > 0) {
                      qty--;
                    }
                  });
                },
                icon: Icon(Icons.remove),
                color: Colors.black,
              ),
              Text(
                widget.product['stok'] - qty > 0
                    ? 'Qty: $qty'
                    : 'Max Qty: ${widget.product['stok']}',
                style: TextStyle(
                  color: Color.fromARGB(255, 35, 35, 35),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (qty < widget.product['stok']) {
                      qty++;
                    }
                  });
                },
                icon: Icon(Icons.add),
                color: Colors.black,
              ),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _addToCart,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              primary: Color.fromARGB(188, 209, 0, 0),
              padding: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 24,
              ),
              minimumSize: Size(4, 4),
            ),
            child: Text(
              'Add to Cart',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
