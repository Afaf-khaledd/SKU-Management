import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';

class CustomMainButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double width;
  const CustomMainButton({super.key, required this.label, required this.onPressed, this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 13.0,left: 13,bottom: 10,),
      child: SizedBox(
        width: width,
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsManager.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
            shadowColor: Color.fromRGBO(3, 19, 20, 0.8),
          ),
          onPressed: onPressed,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width*0.05,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}