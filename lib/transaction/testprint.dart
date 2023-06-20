import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'dart:typed_data' show Uint8List;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:uipos2/mainmenu/account_screen.dart';
import 'package:uipos2/mainmenu/home_screen.dart';
import 'package:uipos2/mainmenu/menu_screen.dart';
import 'package:uipos2/mainmenu/payment_screen.dart';
import 'dart:io';
import 'package:uipos2/transaction/printerenum.dart';
import 'package:uipos2/transaction/transaction_screen.dart';
import 'package:uipos2/theme/bottomnavbar.dart';
import '../theme/cappbar.dart';

class TestPrint extends StatefulWidget {
  final int idtransaksi;

  const TestPrint({Key? key, required this.idtransaksi}) : super(key: key);

  @override
  _TestPrintState createState() => _TestPrintState();
}

class _TestPrintState extends State<TestPrint> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<String> printedTexts = [];

  @override
  void initState() {
    super.initState();
    sample();
  }

  Future<void> sample() async {
    String filename = 'logoOlseller.png';
    ByteData bytesData =
        await rootBundle.load('assets/images/logoOlseller.png');
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = await File('$dir/$filename').writeAsBytes(bytesData.buffer
        .asUint8List(bytesData.offsetInBytes, bytesData.lengthInBytes));

    ByteData bytesAsset =
        await rootBundle.load('assets/images/logoOlseller.png');
    Uint8List imageBytesFromAsset = bytesAsset.buffer
        .asUint8List(bytesAsset.offsetInBytes, bytesAsset.lengthInBytes);

    var responseNetwork = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/kakzaki/blue_thermal_printer/master/example/assets/images/yourlogo.png'));
    Uint8List bytesNetwork = responseNetwork.bodyBytes;
    Uint8List imageBytesFromNetwork = bytesNetwork.buffer
        .asUint8List(bytesNetwork.offsetInBytes, bytesNetwork.lengthInBytes);

    var url = Uri.parse(
        'https://api.couplemoment.com/detailtransaksi/${widget.idtransaksi}');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<dynamic> detailtransactionData = data['data'];
      num totalPrice = detailtransactionData.fold<num>(
        0,
        (total, product) => total + product['harga'] * product['qty'],
      );
      bluetooth.isConnected.then((isConnected) async {
        if (isConnected == true) {
          await bluetooth.printNewLine();
          await bluetooth.printCustom(
              'OLSELLER', Size.boldMedium.val, Aligntext.center.val);
          await bluetooth.printNewLine();
          await bluetooth.printImageBytes(imageBytesFromAsset);
          await bluetooth.printNewLine();
          await bluetooth.printNewLine();
          await bluetooth.printLeftRight(
            'INVOICE : CST/${DateFormat("dd/MM/yyyy").format(DateTime.now())}',
            '',
            Size.medium.val,
          );
          await bluetooth.printLeftRight('CASHIER : Admin', '', Size.bold.val);
          await bluetooth.printNewLine();
          await bluetooth.print3Column('Name', 'Qty', 'Price', Size.bold.val);
          await bluetooth.printCustom('--------------------------------',
              Size.medium.val, Aligntext.center.val);

          for (var item in detailtransactionData) {
            String name = item['nama'];
            int qty = item['qty'];
            int price = item['harga'];
            int totalPrice = qty * price;

            String formattedName = name.padRight(15);
            String formattedQty = qty.toString().padLeft(5);
            String formattedPrice = price.toString().padLeft(10);

            String formattedItem =
                '$formattedName$formattedQty$formattedPrice\n';
            await bluetooth.printCustom(
                formattedItem, Size.medium.val, Aligntext.left.val);
          }

          print(totalPrice);
          await bluetooth.printCustom('--------------------------------',
              Size.medium.val, Aligntext.center.val);
          await bluetooth.print3Column(
              'Total', '  ', totalPrice.toString(), Size.bold.val);
          await bluetooth.printNewLine();
          await bluetooth.printCustom(
              'Terima Kasih', Size.bold.val, Aligntext.center.val);
          await bluetooth.printNewLine();
          await bluetooth.printQRcode(
              'instagram.com/hilmanadiyahya', 200, 200, Aligntext.center.val);
          await bluetooth.printNewLine();

          await bluetooth.paperCut();
          await bluetooth.printCustom('--------------------------------',
              Size.medium.val, Aligntext.center.val);
        }
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

  bool printingInProgress = false; // Track printing progress

  void startPrinting() async {
    setState(() {
      printingInProgress = true;
    });

    DateTime startTime = DateTime.now();

    // Simulate printing process
    await sample();

    DateTime endTime = DateTime.now();
    Duration timeTaken = endTime.difference(startTime);
    print('Printing time: ${timeTaken.inSeconds} seconds');

    setState(() {
      printingInProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Print',
        breadcrumbItem: 'Perangkat',
        breadcrumbItem2: 'Cetak Struk',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sedang Mencetak Struk',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(width: 16),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              children: printedTexts.map((text) => Text(text)).toList(),
            ),
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
