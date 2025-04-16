import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/helper/BottomNavHandler.dart';

class SKUsListScreen extends StatelessWidget {
  const SKUsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Colors.white60,
          title: Text("SKU List",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 25),),
          centerTitle: true,
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.add_box_outlined),tooltip: 'Add new Item',),
            SizedBox(width: 11,),
          ],
        ),
        bottomNavigationBar: BottomNavHandler(
          currentIndex: 2,
        )
    );
  }
}
