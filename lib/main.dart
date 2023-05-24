import 'package:flutter/material.dart';
import 'package:uipos2/landing_page.dart';
import 'package:uipos2/mainmenu/home_screen.dart';

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

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Tunggu beberapa detik (misalnya 3 detik) menggunakan Timer
    Future.delayed(Duration(seconds: 3), () {
      // Pindah ke halaman utama aplikasi
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LandingPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(
          255, 228, 171, 0), // Warna latar belakang splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/landing.png',
              width: 200, // Lebar gambar splash screen
              height: 200, // Tinggi gambar splash screen
              // Tambahkan atribut `fit` jika diperlukan
              // fit: BoxFit.contain,
            ),
            SizedBox(height: 200), // Tinggi SizedBox untuk spasi
            Text(
              'OLSELLER',
              style: TextStyle(
                fontSize: 15, // Ukuran teks
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.white, // Ketebalan teks
              ),
            ),
          ],
        ),
      ),
    );
  }
}
