import 'package:flutter/material.dart';
import 'package:sku/core/utils/colors.dart';

class CustomWhiteTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final String? Function(String?)? validator;

  const CustomWhiteTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: ColorsManager.subTextBlackColor),
        hintText: hintText,
        hintStyle: TextStyle(color: ColorsManager.subTextBlackColor),
        filled: true,
        fillColor: Colors.white60,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.7),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
        ),
      ),
    );
  }
}