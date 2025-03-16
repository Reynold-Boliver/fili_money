import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:fili_money/constants/file_location.dart';
import 'package:fili_money/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../dashboard/home.dart';
import '../../expenses/expenses_screen.dart';
import '../../income/income_screen.dart';
import '../../paginated_table/async_paginated_table_screen.dart';
import '../../theme/color.dart';

class NavBarMenu extends StatefulWidget {
  const NavBarMenu({super.key});

  @override
  State<NavBarMenu> createState() => _NavBarMenuState();
}

class _NavBarMenuState extends State<NavBarMenu> {
  int _tabIndex = 1;

  final List<Widget> _screens = [
    const ExpensesScreen(hasNotification: true,),
    const IncomeScreen(),
    const HomeScreen(),
    const AsyncPaginatedTableScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CircleNavBar(
        circleColor: Colors.white,
        activeIcons: [
          PhotoIcon(imagePath: expenseIconPath, size: 30, color: AppPalette.teal),
          PhotoIcon(imagePath: incomeIconPath, size: 30, color: AppPalette.teal),
          PhotoIcon(imagePath: dashboardIconPath, color: AppPalette.teal),
          PhotoIcon(imagePath: tableIconPath, color: AppPalette.teal),
          PhotoIcon(imagePath: profileIconPath, size: 30, color: AppPalette.teal),
        ],
        inactiveIcons: [
          PhotoIcon(imagePath: expenseIconPath, size: 30, color: Colors.white),
          PhotoIcon(imagePath: incomeIconPath, size: 30, color: Colors.white),
          PhotoIcon(imagePath: dashboardIconPath, color: Colors.white),
          PhotoIcon(imagePath: tableIconPath, color: Colors.white),
          PhotoIcon(imagePath: profileIconPath, size: 30, color: Colors.white),
        ],
        circleShadowColor: AppPalette.teal,
        color: AppPalette.teal,
        height: 60,
        circleWidth: 60,
        activeIndex: _tabIndex,
        onTap: (index) {
          setState(() => _tabIndex = index);
        },
        elevation: 5,
      ),
      body: _screens[_tabIndex],
    );
  }
}

class PhotoIcon extends StatelessWidget {
  final Color color;
  final double size;
  final String imagePath;

  const PhotoIcon({
    super.key,
    this.color = Colors.white,
    this.size = 24.0,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        imagePath,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        width: size,
        height: size,
      ),
    );
  }
}
