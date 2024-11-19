import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.hintText,
    required this.iconImage,
    required this.isPassword,
    required this.controller,
    this.lineLimit = 1,
    super.key,
  });

  final String hintText;
  final Icon iconImage;
  final bool isPassword;
  final TextEditingController controller;
  final int lineLimit;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        suffixIcon: iconImage,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: Text(
          hintText,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(26),
          borderSide: const BorderSide(
            color: Colors.black87,
          ),
        ),
      ),
      maxLines: lineLimit,
    );
  }
}
