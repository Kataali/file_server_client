import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.contentPadding = const EdgeInsets.all(10),
    this.obscure = false,
    this.keyboard = TextInputType.name,
    this.prefixIcon,
    this.suffixIcon,
  });
  final String hintText;
  final TextEditingController controller;
  final EdgeInsetsGeometry contentPadding;
  final bool obscure;
  final TextInputType keyboard;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return TextFormField(
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "This field cannot be empty";
        }
        return null;
      },
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.only(top: 5, left: 16.0),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: color.secondary, width: 2.0),
          borderRadius: BorderRadius.circular(5),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color.onSecondary, width: 2.0),
          borderRadius: BorderRadius.circular(5),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
            fontSize: 18, color: color.onTertiary, fontWeight: FontWeight.w400),
      ),
      obscureText: obscure,
      keyboardType: keyboard,
    );
  }
}
