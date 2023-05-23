import 'package:flutter/material.dart';
// import 'package:uipos2/signin_screen.dart';
// import 'package:uipos2/landing_page.dart';
// import 'package:uipos2/signup_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String breadcrumbItem;
  final String breadcrumbItem2;
  // final IconData icon;

  CustomAppBar({
    required this.title,
    required this.breadcrumbItem,
    required this.breadcrumbItem2,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 228, 171, 0),
      elevation: 0,
      centerTitle: false,
      titleSpacing: 30,
      automaticallyImplyLeading: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: 15),
          Text(
            title,
            style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  // Handle breadcrumb item 1 press
                },
                child: Text(
                  breadcrumbItem,
                  style: TextStyle(
                    color: Color.fromARGB(221, 255, 255, 255),
                    fontSize: 15,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              SizedBox(width: 10),
              Icon(Icons.arrow_forward_ios_rounded, size: 12),
              SizedBox(width: 10),
              Text(
                breadcrumbItem2,
                style: TextStyle(
                  color: Color.fromARGB(221, 255, 255, 255),
                  fontSize: 15,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80);
}
