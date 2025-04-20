import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sku/core/utils/colors.dart';

class EmptyListView extends StatelessWidget {
  final String title;
  final IconData icon;
  final String desc;
  const EmptyListView({super.key, required this.title, required this.icon, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: MediaQuery.of(context).size.width*0.2, color: Colors.grey),
          SizedBox(height: MediaQuery.of(context).size.height*0.02),
          Text(
            title,
            style: GoogleFonts.poppins(fontSize: MediaQuery.of(context).size.width*0.065, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.01),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w400,color: ColorsManager.subTextBlackColor),
          ),
        ],
      ),
    );
  }
}
