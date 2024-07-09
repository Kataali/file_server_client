import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar(
      {super.key, required this.title, this.leading = const SizedBox()});
  final String title;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return AppBar(
      // toolbarHeight: 70,
      elevation: 0,
      backgroundColor: color.tertiary,
      title: Text(
        title,
        // style: TextStyle(color: color.secondary, fontWeight: FontWeight.w700),
        style: GoogleFonts.playfair(
            fontWeight: FontWeight.w700, color: color.secondary, fontSize: 30),
      ),
      centerTitle: true,
      // leading: IconButton(
      //   onPressed: () {
      //     Navigator.of(context).pop();
      //   },
      //   icon: Icon(
      //     Icons.arrow_back_ios,
      //     size: 24,
      //     color: color.secondary,
      //   ),
      // ),
      leading: leading,
      // leading: null,
    );
  }
}
