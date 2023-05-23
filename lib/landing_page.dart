import 'package:flutter/material.dart';
import 'package:uipos2/signin_screen.dart';
// import 'package:uipos2/landing_page.dart';
import 'package:uipos2/signup_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const LandingPage());
}

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 228, 171, 0),
          elevation: 0,
          centerTitle: false,
          titleSpacing: 35,
          automaticallyImplyLeading: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(0),
            ),
          ),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Selamat Datang!',
                style: TextStyle(
                    fontSize: 20, color: Colors.black, fontFamily: 'Poppins'),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.person_2_outlined,
                color: Colors.black,
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 228, 171, 0),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(70),
                      ),
                    ),
                    child: const SizedBox(
                      height: 300,
                      width: 500,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Image.asset(
                      'assets/images/landing.png',
                      height: 120,
                      width: 120,
                      // fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                  );
                },
                child: const Text(
                  'Sign In',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  minimumSize: const Size(300, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: Color.fromARGB(188, 209, 0, 0),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  minimumSize: const Size(300, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: const Color.fromARGB(188, 209, 0, 0),
                ),
              ),
              SizedBox(height: 100),
              const Text(
                'OLSELLER ',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
