import 'package:flutter/material.dart';

import '../log_in/login_screen.dart';
import '../theme/color.dart';
import '../widget/buttons/primary_button.dart';
import '../widget/logo/logo_painter.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  /// List of pages for the onboarding.
  List<Widget> _buildPages() {
    return [
      // Page 1: Wallet GIF image.
      Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/gif/wallet.gif', height: 250),
            const SizedBox(height: 20),
            const Text(
              'Manage Your Wallet',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppPalette.teal),
            ),
            const SizedBox(height: 10),
            const Text(
              'Keep track of your family expenses and incomes easily.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppPalette.darkBrown),
            ),
          ],
        ),
      ),
      // Page 2: Family image.
      Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/img/fam.png', height: 250),
            const SizedBox(height: 20),
            const Text(
              'Family Budgeting',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppPalette.teal),
            ),
            const Text(
              'Plan and manage your family budget effortlessly.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppPalette.darkBrown),
            ),
          ],
        ),
      ),
      // Page 3: Fili Money SVG logo.
      Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logos/fili_money.png', height: 400),
            const SizedBox(height: 10),
            const Text(
              'Help families learn about money and track their spending, making it easier to save.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppPalette.darkBrown),
            ),
            const SizedBox(height: 20),
            PrimaryButton.filled(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              text: 'Get Started',
            ),
          ],
        ),
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onSkipPressed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = _buildPages();

    return Scaffold(
      appBar: AppBar(
        leading: _currentPage > 0
            ? IconButton(
          icon: Transform.translate(
            offset: Offset(0, 30),
            child: AppIcons.leftArrow(
              size: 30,
            ),
          ),
          onPressed: () {
            if (_currentPage > 0) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            }
          },
        )
            : null,
        actions: [
          // Show "Skip" only if not on the last page.
          if (_currentPage < pages.length - 1)
            TextButton(
              onPressed: _onSkipPressed,
              child: const Text(
                'Skip',
                style: TextStyle(
                    color: AppPalette.teal,
                    fontSize: 19,
                    fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // PageView displaying each onboarding page.
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) => pages[index],
              ),
            ),
            // Page indicator row or "Get Started" button on the last page.
            if (_currentPage < pages.length - 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                    height: 10,
                    width: _currentPage == index ? 20 : 10,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppPalette.teal
                          : AppPalette.darkBrown,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}