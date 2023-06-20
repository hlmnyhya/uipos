import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uipos2/theme/cappbar.dart';
import 'package:uipos2/theme/bottomnavbar.dart';
import 'package:uipos2/mainmenu/home_screen.dart';
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

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isExpanded = false;
  TextEditingController _transactionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _fetchUserData().then((userData) {
      // Lakukan sesuatu dengan data pengguna yang diterima
      print('User data: $userData');
    });

    _fetchdataproduct().then((productData) {
      // Lakukan sesuatu dengan data pengguna yang diterima
      print('Product data: $productData');
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _transactionController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _submitDataToAPI(BuildContext context) async {
    final url = Uri.parse(
        'https://api.couplemoment.com/transaksi/temp'); // API endpoint
    final customerName = _transactionController.text;

    try {
      final response = await http.post(
        url,
        body: {'nama': customerName},
      );

      if (response.statusCode == 200) {
        // Request successful, handle the response if needed
        print('Data submitted successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Request failed, handle the error
        print('Failed to submit data. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to submit data. Status code: ${response.statusCode}'),
          ),
        );
      }
    } catch (error) {
      // Exception occurred during the request
      print('Error submitting data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting data: $error'),
        ),
      );
    }
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    var url = Uri.parse('http://192.168.1.16:4000/user');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        print(data);
        return Map<String, dynamic>.from(data);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }

    return {}; // Return an empty map if there's an error or the response is not successful
  }

  List<Map<String, dynamic>> _cartItems = [];
  int? productId;
  String? productName;
  String? productPrice;
  String? productImage;
  String? productDescription;
  String? productStock;
  // String? userId;
  Map<String, dynamic>? cartproduct;

  Future<List<Map<String, dynamic>>> _fetchdataproduct() async {
    var url = Uri.parse('https://api.couplemoment.com/product');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        print(data);
        return List<Map<String, dynamic>>.from(data);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }

    return []; // Return an empty list if there's an error or the response is not successful
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
      productId = product['id_product'].toInt();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DetailScreen(idProduct: productId, product: product)),
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
              'Stok Habis',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            content: Text('Stok produk ini sudah habis'),
            actions: [
              TextButton(
                onPressed: () {
                  productId = product['id_product'].toInt();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailScreen(
                            idProduct: productId, product: product)),
                  );
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
        title: 'Produk',
        breadcrumbItem: 'Produk',
        breadcrumbItem2: 'Semua Produk',
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
              _toggleExpanded();
            },
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _animationController,
            ),
            backgroundColor: Color.fromARGB(188, 209, 0, 0),
          ),
          SizedBox(height: 16),
          AnimatedCrossFade(
            duration: Duration(milliseconds: 300),
            firstChild: SizedBox(),
            secondChild: Visibility(
              visible: _isExpanded,
              child: Column(
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            title: Text(
                              'Buat Transaksi',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            content: TextFormField(
                              controller: _transactionController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'Nama Pelanggan',
                                labelStyle: TextStyle(
                                    color: Colors.black, fontFamily: 'Poppins'),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(188, 209, 0, 0),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(188, 209, 0, 0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(188, 209, 0, 0),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 24,
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your customer name';
                                }
                                return null;
                              },
                            ),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Fix: Wrap MainAxisAlignment.spaceBetween widget around children
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      primary: Color.fromARGB(188, 209, 0, 0),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 24,
                                      ),
                                      minimumSize: Size(4, 4),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.cancel,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Batal',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16), // Jarak antara tombol
                                  ElevatedButton(
                                    onPressed: () {
                                      _submitDataToAPI(
                                          context); // Call the function to submit data to the API
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MenuScreen()),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      primary: Color.fromARGB(188, 209, 0, 0),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 24,
                                      ),
                                      minimumSize: Size(4, 4),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.save,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Simpan',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(CupertinoIcons.cart_fill_badge_plus),
                    backgroundColor: Color.fromARGB(255, 228, 171, 0),
                  ),
                  SizedBox(height: 16),
                  FloatingActionButton(
                    onPressed: () {
                      // Tambahkan kode aksi untuk tombol lain di sini
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MenuScreenAdd()),
                      );
                      print('Button 2 pressed');
                    },
                    child: Icon(CupertinoIcons.cube_box),
                    backgroundColor: Color.fromARGB(188, 209, 0, 0),
                  ),
                ],
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
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
                    product['nama'] ?? 'Nama Produk',
                    style: TextStyle(
                      color: Color.fromARGB(255, 35, 35, 35),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    product['deskripsi'] ?? 'Deskripsi Produk',
                    style: TextStyle(
                      color: Color.fromARGB(255, 35, 35, 35),
                      fontSize: 10,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Rp. ${product['harga']},-' ?? 'Harga Produk',
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
              child: FloatingActionButton(
                onPressed: () {
                  cartproduct = product;
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
                child: Icon(Icons.add, color: Colors.white, size: 25),
                backgroundColor: Color.fromARGB(188, 209, 0, 0),
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
        Uri.parse('https://api.couplemoment.com/temptransaksi/add'),
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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Berhasil ditambahkan ke keranjang'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Close the dialog
        Navigator.pop(context);
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
        'Tambah ke Keranjang',
        style: TextStyle(
          fontSize: 16,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  'Tambah ke Keranjang',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
