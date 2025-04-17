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
          Icon(icon, size: 100, color: Colors.grey),
          const SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400,color: ColorsManager.subTextBlackColor),
          ),
        ],
      ),
    );
  }
}
