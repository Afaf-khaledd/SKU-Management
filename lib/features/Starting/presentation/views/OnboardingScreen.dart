import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sku/core/components/customMainButton.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/utils/colors.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 20 : 40),
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                AssetsManager.logo,
                fit: BoxFit.contain,
                width: screenWidth * 0.5,
                height: screenHeight * 0.3,
              ),
              const SizedBox(height: 20),
              Text(
                'Inventura',
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 26 : 32,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Inventura helps you manage your inventory, generate and scan QR codes, and filter items easily. Stay organized and gain insights with a simple, visual dashboard.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.w400,
                  color: ColorsManager.subTextBlackColor,
                ),
              ),
              const Spacer(),
              CustomMainButton(
                label: 'Get Started',
                onPressed: () {
                  context.push('/login');
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}