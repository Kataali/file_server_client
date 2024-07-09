import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.color,
      this.leading = const SizedBox()});
  final String text;
  final Function() onPressed;
  final Color? color;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 70,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
          onPressed();
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: color ?? colorScheme.primary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leading,
            const VerticalDivider(
              thickness: 0.001,
              width: 10,
            ),
            Text(
              text,
              style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
