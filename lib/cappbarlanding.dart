import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required this.backgroundImage,
    this.title = '',
    this.titleColor = Colors.white,
    this.titleFontSize = 24.0,
    this.height = 200.0,
    this.leading,
    this.actions,
  }) : super(key: key);

  final String backgroundImage;
  final String title;
  final Color titleColor;
  final double titleFontSize;
  final double height;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: titleColor,
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: kToolbarHeight / 2 - 20,
          child: Row(
            children: [
              if (leading != null) leading!,
              const Spacer(),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ],
    );
  }
}
