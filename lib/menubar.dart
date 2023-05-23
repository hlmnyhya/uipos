import 'package:flutter/material.dart';
import 'package:uipos2/mainmenu/home_screen.dart';

class CustomMenuBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomMenuBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(188, 209, 0, 0),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.16),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          items: buildMenuItem(),
          currentIndex: currentIndex,
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
          onTap: onTap,
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> buildMenuItem() {
    return [
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
          radius: 15,
          child: Icon(Icons.qr_code, color: Colors.white, size: 20),
        ),
        label: 'Payment',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.list_alt_outlined),
        label: 'Order',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        label: 'Account',
      ),
    ];
  }
}
