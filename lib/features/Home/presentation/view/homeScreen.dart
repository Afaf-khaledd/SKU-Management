import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sku/features/Authentication/presentation/logic/auth_event.dart';
import 'package:sku/features/Home/presentation/view/dash_card.dart';
import 'package:sku/features/SKUs/presentation/logic/items_bloc.dart';
import 'package:sku/features/SKUs/presentation/logic/items_event.dart';
import 'package:sku/features/SKUs/presentation/logic/items_state.dart';

import '../../../../core/helper/BottomNavHandler.dart';
import '../../../Authentication/presentation/logic/auth_bloc.dart';
import '../../../Branches/presentation/logic/branch_bloc.dart';
import '../../../Branches/presentation/logic/branch_event.dart';
import '../../../Branches/presentation/logic/branch_state.dart';
import 'category_pie_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    context.read<ItemsBloc>().add(LoadSKUs());
    context.read<BranchBloc>().add(FetchBranches());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.13,
        backgroundColor: Colors.transparent,
        title: Text("Welcome, Admin👋🏻",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: screenWidth*0.06),),
        actions: [
          IconButton(
            onPressed: (){
              context.read<AuthBloc>().add(LogoutRequested());
              context.go('/onboarding');
            },
            icon: Icon(Icons.login_outlined),
          ),
          SizedBox(width: 8,),
        ],
      ),
      bottomNavigationBar: BottomNavHandler(
      currentIndex: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dashboard",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: screenWidth*0.08),
              ),
              SizedBox(height: screenHeight*0.007),
              BlocBuilder<ItemsBloc, ItemsState>(
                builder: (context, skuState) {
                  if (skuState is SKULoaded) {
                    final activeItems = skuState.items.where((sku) => sku.isActive).length;
                    final inactiveItems = skuState.items.where((sku) => !sku.isActive).length;
                    final brands = skuState.items.map((sku) => sku.brand.toLowerCase()).toSet().length;

                    return BlocBuilder<BranchBloc, BranchState>(
                      builder: (context, branchState) {
                        if (branchState is BranchLoaded) {
                          final branchCount = branchState.branches.length;
                          final items = [
                            {'text': 'Active Items', 'number': activeItems},
                            {'text': 'Inactive Items', 'number': inactiveItems},
                            {'text': 'Brands', 'number': brands},
                            {'text': 'Branches', 'number': branchCount},
                          ];
                          return SizedBox(
                            height: screenHeight*0.34,
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                childAspectRatio: 1.2,
                              ),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                return DashCard(
                                  text: items[index]['text'] as String,
                                  number: items[index]['number'] as int,
                                );
                              },
                            ),
                          );
                        } else {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              child: Container(
                                height: screenHeight*0.32,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  } else {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Container(
                          height: screenHeight*0.32,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: screenHeight*0.007),
              Text(
                "Statistics for count for each category",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: screenWidth*0.064),
              ),
              Center(
                child: CategoryPieChart(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
