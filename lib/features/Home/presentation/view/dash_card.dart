import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sku/core/utils/colors.dart';

class DashCard extends StatelessWidget {
  final String text;
  final int number;
  const DashCard({super.key, required this.text, required this.number});

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).size.width;
    return Card(
      color: Colors.grey[300],
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: GoogleFonts.poppins(fontSize: MediaQuery.of(context).size.width*0.04,fontWeight: FontWeight.w500),
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.015,),
          Text(
            '$number',
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width*0.04,
              fontWeight: FontWeight.bold,
              color: ColorsManager.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
