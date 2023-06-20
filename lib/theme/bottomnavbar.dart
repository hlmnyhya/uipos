import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_sharp),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: 'Produk',
        ),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            backgroundColor: Color.fromARGB(188, 209, 0, 0),
            radius: 30,
            child: Icon(CupertinoIcons.qrcode, color: Colors.white, size: 30),
          ),
          label: 'Bayar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_outlined),
          label: 'Pesan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_2_outlined),
          label: 'Akun',
        ),
      ],
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
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}
