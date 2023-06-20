import 'package:flutter/material.dart';
import 'package:uipos2/landing_page.dart';
import 'package:uipos2/mainmenu/home_screen.dart';
import 'package:uipos2/splashscreen/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // debugcheckBannerEnabled: false,
    return MaterialApp(
      title: 'OLSELLER',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),

      // Gunakan SplashScreen sebagai halaman utama
    );
  }
}
