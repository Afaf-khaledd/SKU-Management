import 'package:flutter/material.dart';
import 'package:sku/core/utils/colors.dart';
import 'package:sku/core/utils/colors.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  const CustomFormField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 3),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 15,
                offset: const Offset(3, 1),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              prefixIcon: Icon(prefixIcon, color: ColorsManager.subTextBlackColor),
              hintText: hintText,
              hintStyle: const TextStyle(color: ColorsManager.subTextBlackColor),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        )

    );
  }
}
