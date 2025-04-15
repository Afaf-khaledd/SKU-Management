import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: ColorsManager.BGColor,
        focusColor: ColorsManager.blackColor,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: ColorsManager.primaryColor,
          selectionColor: ColorsManager.primaryColor,
          selectionHandleColor: ColorsManager.primaryColor,
        ),
        primaryColor: ColorsManager.blackColor,
        textTheme: GoogleFonts.dmSansTextTheme().copyWith(
          bodyLarge: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400, color: Colors.black),
          bodyMedium: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400, color: Colors.black),
          bodySmall: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400, color: Colors.black),
          titleLarge: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400, color: Colors.black),
          titleMedium: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400, color: Colors.black),
          titleSmall: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400, color: Colors.black),
        ),
      ),
      home: const Placeholder(),//SplashScreen(),
    );
  }
}