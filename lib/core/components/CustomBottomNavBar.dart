import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  final List<TabItem> items = [
    TabItem(icon: Icons.home_outlined,title: 'Home'),
    TabItem(icon: Icons.location_on_outlined, title: 'Branches'),
    TabItem(icon: Icons.grid_on_outlined,title: 'Items'),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomBarDefault(
      items: items,
      backgroundColor: Colors.white60,
      color: Colors.black,
      iconSize: 22,
      colorSelected: ColorsManager.primaryColor,
      indexSelected: widget.currentIndex,
      onTap: widget.onTap,
      enableShadow: true,
      paddingVertical: 20,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          spreadRadius: 2,
          offset: const Offset(0, 1.7),
        ),
      ],
      borderRadius: BorderRadius.circular(2),
    );
  }
}
