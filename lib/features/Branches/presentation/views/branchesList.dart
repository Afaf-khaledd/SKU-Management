import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sku/core/components/emptyListView.dart';
import 'package:sku/core/utils/assets.dart';

import '../../../../core/components/customCard.dart';
import '../../../../core/components/shimmerCards.dart';
import '../../../../core/helper/BottomNavHandler.dart';
import '../logic/branch_bloc.dart';
import '../logic/branch_event.dart';
import '../logic/branch_state.dart';

class BranchesListScreen extends StatelessWidget {
  const BranchesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        title: Text(
          "Branch List",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 25),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => context.push('/branch'),
            icon: const Icon(Icons.add_business_outlined),
            tooltip: 'Add new Branch',
          ),
          const SizedBox(width: 11),
        ],
      ),
      bottomNavigationBar: BottomNavHandler(currentIndex: 1),
      body: BlocBuilder<BranchBloc, BranchState>(
        builder: (context, state) {
          if (state is BranchLoading) {
            return const ShimmerCards();
          } else if (state is BranchLoaded) {
            final branches = state.branches;

            if (branches.isEmpty) {
              return const EmptyListView(title: 'No branches found.', icon: Icons.add_business_outlined, desc: "There's no branches yet,\nYou can add new branches easy!"); // good ui
            }

            return ListView.builder(
              itemCount: branches.length,
              itemBuilder: (context, index) {
                final branch = branches[index];
                return CustomCard(
                  title: branch.name,
                  subtitles: [
                    'Location: ${branch.location}',
                    'Manager: ${branch.managerName}',
                    'Phone: ${branch.phone}',
                  ],
                  trailing: Image.asset(AssetsManager.map,),
                  onTap: () {
                    context.push('/branch', extra: branch);
                  },
                  onDelete: () {
                    context.read<BranchBloc>().add(DeleteBranch(branch.id!));
                  },
                );
              },
            );
          } else if (state is BranchError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}