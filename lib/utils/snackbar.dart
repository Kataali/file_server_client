import 'package:flutter/material.dart';

class CustomSnackbar {
  final String message;
  final Color color;
  const CustomSnackbar({
    required this.message,
    this.color = Colors.black26,
  });

  static show(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: const EdgeInsets.only(bottom: 30),
        padding: const EdgeInsets.fromLTRB(10, 25, 10, 25),
        duration: const Duration(seconds: 1, milliseconds: 500),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Text(message),
      ),
    );
  }
}
