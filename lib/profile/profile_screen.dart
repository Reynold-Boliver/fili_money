import 'package:fili_money/developers/developer_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../log_in/login_screen.dart';
import '../theme/color.dart';
import '../theme/text_style.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  Widget _buildUserDataField({
    required BuildContext context,
    required String label,
    required String value,
    VoidCallback? onEdit,
  }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          const BoxShadow(
            color: Colors.white10,
            offset: Offset(-6, -6),
            blurRadius: 6,
          ),
          BoxShadow(
            color: AppPalette.teal.withAlpha(80),
            offset: const Offset(6, 6),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppPalette.teal, fontSize: 14)),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppPalette.teal,
                  ),
                ),
              ),
              if (onEdit != null)
                IconButton(
                  icon: const Icon(Icons.edit_rounded, color: AppPalette.teal),
                  onPressed: onEdit,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showSingleFieldEditDialog({
    required BuildContext context,
    required String title,
    required String currentValue,
    required String fieldKey,
    required String userId,
  }) async {
    final TextEditingController controller = TextEditingController(text: currentValue);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $title", style: const TextStyle(color: AppPalette.teal)),
        content: SingleChildScrollView(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: title,
              labelStyle: const TextStyle(color: AppPalette.teal),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel", style: TextStyle(color: AppPalette.teal)),
          ),
          TextButton(
            onPressed: () async {
              final newValue = controller.text.trim();
              if (newValue.isNotEmpty && newValue != currentValue) {
                await FirebaseFirestore.instance.collection('users').doc(userId).update({fieldKey: newValue});
              }
              if (!mounted) return;
              Navigator.of(context).pop();
            },
            child: const Text("Save", style: TextStyle(color: AppPalette.teal)),
          ),
        ],
      ),
    );
  }

  Future<void> _showNameEditDialog({
    required BuildContext context,
    required String currentFirstName,
    required String currentLastName,
    required String userId,
  }) async {
    final firstNameController = TextEditingController(text: currentFirstName);
    final lastNameController = TextEditingController(text: currentLastName);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Name", style: TextStyle(color: AppPalette.teal)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  labelText: "First Name",
                  labelStyle: TextStyle(color: AppPalette.teal),
                ),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  labelText: "Last Name",
                  labelStyle: TextStyle(color: AppPalette.teal),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel", style: TextStyle(color: AppPalette.teal)),
          ),
          TextButton(
            onPressed: () async {
              final newFirstName = firstNameController.text.trim();
              final newLastName = lastNameController.text.trim();
              if (newFirstName.isNotEmpty && newLastName.isNotEmpty &&
                  (newFirstName != currentFirstName || newLastName != currentLastName)) {
                await FirebaseFirestore.instance.collection('users').doc(userId).update({
                  'firstName': newFirstName,
                  'lastName': newLastName,
                });
              }
              if (!mounted) return;
              Navigator.of(context).pop();
            },
            child: const Text("Save", style: TextStyle(color: AppPalette.teal)),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddProfileDialog({
    required BuildContext context,
    required String userId,
  }) async {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final addressController = TextEditingController();
    final ageController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Profile Information", style: TextStyle(color: AppPalette.teal)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  labelText: "First Name",
                  labelStyle: TextStyle(color: AppPalette.teal),
                ),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  labelText: "Last Name",
                  labelStyle: TextStyle(color: AppPalette.teal),
                ),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: "Address",
                  labelStyle: TextStyle(color: AppPalette.teal),
                ),
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(
                  labelText: "Age",
                  labelStyle: TextStyle(color: AppPalette.teal),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel", style: TextStyle(color: AppPalette.teal)),
          ),
          TextButton(
            onPressed: () async {
              final firstName = firstNameController.text.trim();
              final lastName = lastNameController.text.trim();
              final address = addressController.text.trim();
              final ageText = ageController.text.trim();
              if (firstName.isNotEmpty && lastName.isNotEmpty && address.isNotEmpty && ageText.isNotEmpty) {
                await FirebaseFirestore.instance.collection('users').doc(userId).set({
                  'firstName': firstName,
                  'lastName': lastName,
                  'email': FirebaseAuth.instance.currentUser?.email ?? "",
                  'address': address,
                  'age': int.tryParse(ageText) ?? 0,
                });
              }
              if (!mounted) return;
              Navigator.of(context).pop();
            },
            child: const Text("Save", style: TextStyle(color: AppPalette.teal)),
          ),
        ],
      ),
    );
  }

  void gotoLogInScreen() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: Text('No user is currently signed in.')),
      );
    }

    final userDocStream = FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: AppTextStyles.heading),
        backgroundColor: AppPalette.teal.withAlpha(25),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppPalette.teal),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              gotoLogInScreen();
            },
          ),
        ],
      ),
      backgroundColor: AppPalette.teal.withAlpha(25),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userDocStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No user data found. Please add your profile information.',
                    style: TextStyle(color: AppPalette.teal),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _showAddProfileDialog(context: context, userId: user.uid);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPalette.teal,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Add Profile Data'),
                  ),
                ],
              ),
            );
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final firstName = userData['firstName'] ?? '';
          final lastName = userData['lastName'] ?? '';
          final email = userData['email'] ?? '';
          final address = userData['address'] ?? '';
          final age = userData['age'] ?? '';
          final googlePhotoUrl = user.photoURL;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: googlePhotoUrl != null
                        ? NetworkImage(googlePhotoUrl)
                        : const AssetImage('assets/placeholder_avatar.png') as ImageProvider,
                  ),
                  const SizedBox(height: 20),
                  _buildUserDataField(
                    context: context,
                    label: 'Name',
                    value: '$firstName $lastName',
                    onEdit: () {
                      _showNameEditDialog(
                        context: context,
                        currentFirstName: firstName,
                        currentLastName: lastName,
                        userId: user.uid,
                      );
                    },
                  ),
                  _buildUserDataField(
                    context: context,
                    label: 'Email',
                    value: email,
                  ),
                  _buildUserDataField(
                    context: context,
                    label: 'Address',
                    value: address,
                    onEdit: () {
                      _showSingleFieldEditDialog(
                        context: context,
                        title: 'Address',
                        currentValue: address,
                        fieldKey: 'address',
                        userId: user.uid,
                      );
                    },
                  ),
                  _buildUserDataField(
                    context: context,
                    label: 'Age',
                    value: age.toString(),
                    onEdit: () {
                      _showSingleFieldEditDialog(
                        context: context,
                        title: 'Age',
                        currentValue: age.toString(),
                        fieldKey: 'age',
                        userId: user.uid,
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Get to know us '),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  DeveloperScreen()),
                          );
                        },
                        child: const Text(
                          "Developers",
                          style: TextStyle(color: AppPalette.teal, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                   SizedBox(height: 60),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
