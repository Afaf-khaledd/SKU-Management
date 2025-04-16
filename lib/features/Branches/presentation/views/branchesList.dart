import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/helper/BottomNavHandler.dart';

class BranchesListScreen extends StatelessWidget {
  const BranchesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Colors.white60,
          title: Text("Branch List",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 25),),
          centerTitle: true,
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.add_business_outlined),tooltip: 'Add new Branch',),
            SizedBox(width: 11,),
          ],
        ),
        bottomNavigationBar: BottomNavHandler(
          currentIndex: 1,
        )
    );
  }
}
