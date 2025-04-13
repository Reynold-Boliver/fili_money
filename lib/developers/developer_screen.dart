import 'package:fili_money/theme/color.dart';
import 'package:fili_money/theme/text_style.dart';
import 'package:flutter/material.dart';

import '../constants/file_location.dart';

void main() => runApp(DeveloperScreen());

class DeveloperScreen extends StatelessWidget {
  final List<Map<String, String>> teamMembers = [
    {
      'name': 'Maria Lous Balgos',
      'role': 'Programmer/Researcher',
      'image': mariaLousImagePath,
    },
    {
      'name': 'Erica Domoos',
      'role': 'Designer/Researcher',
      'image': ericaImagePath,
    },
    {
      'name': 'Dexter Baclas',
      'role': 'Researcher/Story Board Creator',
      'image': dexterImagePath,
    },
    {
      'name': 'Ayeza Badhay',
      'role': 'Researcher/Planning Assistant',
      'image': ayezaImagePath,
    },
  ];

  DeveloperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Developers', style: AppTextStyles.heading),
          backgroundColor: AppPalette.teal.withAlpha(25),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded, color: AppPalette.teal),
              onPressed: () async {
                // navigation pop
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Center(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: teamMembers.length,
            itemBuilder: (context, index) {
              final member = teamMembers[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(member['image']!),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      member['name']!,
                      style: const TextStyle(
                        color: AppPalette.teal,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      member['role']!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppPalette.teal,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
