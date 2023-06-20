import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:uipos2/order/order_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uipos2/mainmenu/home_screen.dart';
import 'package:uipos2/mainmenu/menu_screen.dart';
import 'package:uipos2/mainmenu/payment_screen.dart';
import 'package:uipos2/mainmenu/account_screen.dart';
import 'package:uipos2/transaction/transaction_screen.dart';
import 'package:uipos2/theme/bottomnavbar.dart';

class MidtransSnapScreen extends StatefulWidget {
  final int idtransaksi;

  const MidtransSnapScreen({
    Key? key,
    required this.idtransaksi,
  }) : super(key: key);
  @override
  _MidtransSnapScreenState createState() => _MidtransSnapScreenState();
}

class _MidtransSnapScreenState extends State<MidtransSnapScreen> {
  InAppWebViewController? _webViewController;
  bool _isLoading = true;
  String? _snapUrl;
  String? _errorMessage; // Tambahkan variabel untuk pesan error

  Future<void> fetchOnlinePayment() async {
    try {
      var url = Uri.parse(
          'https://api.couplemoment.com/transaksi/trans/onlinepayment');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var snapUrl = data['transactionRedirectUrl'];
        print(snapUrl);

        setState(() {
          _snapUrl = snapUrl;
        });
      } else {
        setState(() {
          _errorMessage =
              'Transaction has been checkout'; // Set pesan error jika gagal mengambil data
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage =
            'An error occurred'; // Set pesan error jika terjadi kesalahan
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOnlinePayment();
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
        MaterialPageRoute(
          builder: (context) =>
              OrderDetailScreen(idtransaksi: widget.idtransaksi),
        ),
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
    return Scaffold(
      body: Stack(
        children: [
          if (_snapUrl != null)
            InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(_snapUrl!)),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  // Aktifkan JavaScript
                  javaScriptEnabled: true,
                ),
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                _webViewController = controller;
              },
              onLoadStop: (controller, url) {
                setState(() {
                  _isLoading = false;
                });
              },
            ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(188, 209, 0, 0),
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
              _webViewController?.reload();
            },
            child: Icon(Icons.refresh),
            backgroundColor: Color.fromARGB(188, 209, 0, 0),
          ),
          SizedBox(height: 16), // Jarak antara tombol
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TransactionScreen(idtransaksi: widget.idtransaksi),
                ),
              );
            },
            child: Icon(Icons.print),
            backgroundColor: Color.fromARGB(188, 209, 0, 0),
          ),
        ],
      ),
      bottomSheet: _errorMessage != null // Tampilkan pesan error jika ada
          ? Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              color: Colors.red,
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.white),
              ),
            )
          : null,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
