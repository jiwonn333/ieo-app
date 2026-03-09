import 'package:flutter/material.dart';

class IeoTextField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  const IeoTextField({
    super.key,
    required this.labelText,
    this.hintText,
    this.keyboardType,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: labelText, hintText: hintText),
    );
  }
}
