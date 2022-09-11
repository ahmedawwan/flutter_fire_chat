import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField(
      {super.key,
      required this.textFieldColor,
      required this.hintText,
      required this.textEditingController, required this.obscureText});

  final Color textFieldColor;
  final String hintText;
  final TextEditingController textEditingController;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      controller: textEditingController,
      style: TextStyle(color: textFieldColor),
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: Colors.grey),
        hintText: hintText,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(32.0),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: textFieldColor, width: 1.0),
          borderRadius: const BorderRadius.all(
            Radius.circular(32.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: textFieldColor, width: 2.0),
          borderRadius: const BorderRadius.all(
            Radius.circular(32.0),
          ),
        ),
      ),
    );
  }
}
