import 'package:fili_money/firebase_options.dart';
import 'package:fili_money/on_boarding/on_boarding_screens.dart';
import 'package:fili_money/services/image_cacher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await precacheInitialAssets();
  runApp(const MyApp());
}

Future<void> precacheInitialAssets() async {
  // Precache only the initial SVG assets that are needed immediately.
  await Future.wait([
    precacheSvgPicture('assets/icons/expense.svg'),
    precacheSvgPicture('assets/icons/income.svg'),
    precacheSvgPicture('assets/icons/profile.svg'),
    precacheSvgPicture('assets/icons/dashboard.svg'),

  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen());
  }
}