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
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
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
                  color: Colors.black)
          ),
          SizedBox(height: 10,),
          Text(
              'Showcasing app features for effective\n inventory control.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: ColorsManager.subTextBlackColor)
          ),
          Spacer(),
          CustomMainButton(label: 'Get Start',onPressed: (){
            context.push('/login');
          },),
        ],
      ),
    );
  }
}
