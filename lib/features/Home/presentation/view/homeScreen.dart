import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/helper/BottomNavHandler.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.white60,
        title: Text("Welcome, Admin👋🏻",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 23),),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.login_outlined)),
          SizedBox(width: 8,),
        ],
      ),
    bottomNavigationBar: BottomNavHandler(
    currentIndex: 0,
    )
    );
  }
}
