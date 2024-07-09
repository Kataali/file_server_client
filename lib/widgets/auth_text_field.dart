import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
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

    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        validator: (value) {
          if (value!.trim().isEmpty) {
            return "Required Field missing";
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
            borderRadius: BorderRadius.circular(25),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color.onTertiary, width: 2.0),
            borderRadius: BorderRadius.circular(25),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: 18,
              color: color.onTertiary,
              fontWeight: FontWeight.w400),
        ),
        obscureText: obscure,
        keyboardType: keyboard,
      ),
    );
  }
}
