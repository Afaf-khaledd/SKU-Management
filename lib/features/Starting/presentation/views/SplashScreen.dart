import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      context.go('/onboarding');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetsManager.logo,
              fit: BoxFit.contain,
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20,),
            Text(
              'SKU Management System',
              style: GoogleFonts.poppins(
                fontSize: 23,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
                color: Colors.black
              )
            ),
          ],
        ),
      ),
    );
  }
}
