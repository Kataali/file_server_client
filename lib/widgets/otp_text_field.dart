import 'package:flutter/material.dart';

class OtpTextField extends StatelessWidget {
  const OtpTextField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Container(
      height: 90,
      width: 65,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: color.secondary, width: 1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            maxLength: 1,
            textInputAction: TextInputAction.next,
            controller: controller,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: 30,
              color: color.secondary,
            ),
            decoration: const InputDecoration(
              hintText: "0",
              counterText: "",
              hintStyle: TextStyle(
                fontSize: 30,
              ),
              border: InputBorder.none,
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                FocusScope.of(context).nextFocus();
              }
            },
          ),
        ],
      ),
    );
  }
}
