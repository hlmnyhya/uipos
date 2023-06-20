import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uipos2/mainmenu/home_screen.dart';
import 'package:uipos2/mainmenu/menu_screen.dart';
import 'package:uipos2/menu/menu_add_screen.dart';
import 'package:uipos2/menu/menu_edit_screen.dart';
import 'package:uipos2/mainmenu/payment_screen.dart';
import 'package:uipos2/mainmenu/order_screen.dart';
import '../theme/cappbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uipos2/theme/bottomnavbar.dart';

class DetailScreen extends StatefulWidget {
  final dynamic idProduct;
  final dynamic product;

  DetailScreen({required this.idProduct, required this.product});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _selectedIndex = 1;

  Future<void> deleteMenu(String idProduct) async {
    final url =
        Uri.parse('https://api.couplemoment.com/product/${widget.idProduct}');

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      // Berhasil menghapus menu
      print('Menu deleted successfully!');
      setState(() {
        // Perform any necessary state update after deleting the menu
      });
    } else {
      // Gagal menghapus menu
      print('Failed to delete menu. Error: ${response.statusCode}');
    }
  }

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
        MaterialPageRoute(builder: (context) => HomeScreen()),
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
        title: 'Produk',
        breadcrumbItem: 'Produk',
        breadcrumbItem2: 'Detail Produk',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Image.network(
                    widget.product['gambar'] ??
                        'https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product['nama'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.product['deskripsi'],
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Harga : Rp. ${widget.product['harga']},-'.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Stok : ${widget.product['stok']}'.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MenuScreenEdit(
                            idProduct: widget.idProduct,
                            product: widget.product,
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.edit,
                      size: 20,
                    ),
                    label: Text(
                      'Ubah Produk',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      minimumSize: Size(170, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: Color.fromARGB(188, 209, 0, 0),
                      fixedSize: Size(170, 50),
                    ),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: const Text('Konfirmasi Hapus'),
                            content: const Text(
                                'Apakah Anda yakin ingin menghapus produk ini?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () async {
                                  // Panggil fungsi untuk menghapus data
                                  await deleteMenu(
                                      widget.product['id_product']());

                                  // Tutup dialog konfirmasi
                                  Navigator.of(context).pop();

                                  // Kembali ke halaman MenuScreen setelah menghapus
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MenuScreen()),
                                  );
                                },
                                child: const Text('Hapus',
                                    style: TextStyle(color: Colors.red)),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Tutup dialog konfirmasi
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Batal',
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(
                      Icons.delete_forever,
                      size: 20,
                    ),
                    label: Text(
                      'Hapus Produk',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      minimumSize: Size(170, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: Color.fromARGB(188, 209, 0, 0),
                      fixedSize: Size(170, 50),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
