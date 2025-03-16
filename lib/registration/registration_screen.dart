import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fili_money/log_in/login_screen.dart';
import 'package:fili_money/theme/color.dart';
import 'package:fili_money/validation/email_validation.dart';
import 'package:fili_money/validation/password_validation.dart';
import 'package:fili_money/widget/buttons/circular_buttons.dart';
import 'package:fili_money/widget/buttons/primary_button.dart';
import 'package:fili_money/widget/logo/logo_painter.dart';
import 'package:fili_money/widget/text_fields/primary_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widget/navbar/nav_bar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  late EmailValidator _emailValidator;
  late PasswordValidator _passwordValidator;
  late ConfirmPasswordValidator _passwordConfirmationValidator;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailValidator = EmailValidator.pure();
    _passwordValidator = PasswordValidator.pure();
    _passwordConfirmationValidator = ConfirmPasswordValidator.pure();
  }

  Future<void> _register() async {
    if (!_emailValidator.isValid ||
        !_passwordValidator.isValid ||
        !_passwordConfirmationValidator.isValid) {
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);

      User? user = userCredential.user;

      debugPrint('User: $user');
      if (user != null) {
        final userData = {
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'address': _addressController.text,
          'age': _ageController.text,
          'email': _emailController.text,
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(userData)
            .then((_) => debugPrint('User data added to Firestore'))
            .catchError(
                (error) => debugPrint('Failed to add user data: $error'));

        // Navigate to another screen or show success message
        debugPrint('Success');
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NavBarMenu()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuth Error: ${e.message}');
    } on FirebaseException catch (e) {
      debugPrint('Firebase Error: ${e.message}');
    } catch (e) {
      debugPrint('Unknown Error: ${e.toString()}');
    }
  }

  void _validator() {
    setState(() {
      _emailValidator = EmailValidator.dirty(_emailController.text);
      _passwordValidator = PasswordValidator.dirty(_passwordController.text);
      _passwordConfirmationValidator = ConfirmPasswordValidator.dirty(
        value: _passwordController.text,
        password: _confirmPasswordController.text,
      );

      // check if the password and confirmation is the sane
      if (_passwordController.text != _confirmPasswordController.text) {}

      debugPrint('Email: ${_emailValidator.error?.name}');
      debugPrint('Password: ${_passwordValidator.error?.name}');
      debugPrint(
          'Password Confirmation: ${_passwordConfirmationValidator.error?.name}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Transform.translate(
            offset: Offset(0, 30),
            child: AppIcons.leftArrow(
              size: 30,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      color: AppPalette.teal,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 35),
            PrimaryTextField(
              controller: _firstNameController,
              fieldName: 'First Name',
            ),
            SizedBox(height: 20),
            PrimaryTextField(
              controller: _lastNameController,
              fieldName: 'Last Name',
            ),
            SizedBox(height: 20),
            PrimaryTextField(
              controller: _addressController,
              fieldName: 'Address',
            ),
            SizedBox(height: 20),
            PrimaryTextField(
              controller: _ageController,
              fieldName: 'Age',
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            SizedBox(height: 20),
            PrimaryTextField(
              controller: _emailController,
              fieldName: 'Email',
              errorMessage: !_emailValidator.isValid && !_emailValidator.isPure
                  ? _emailValidator.error?.name
                  : null,
            ),
            SizedBox(height: 20),
            PrimaryTextField(
              controller: _passwordController,
              fieldName: 'Password',
              obscureText: true,
              errorMessage:
                  !_passwordValidator.isValid && !_passwordValidator.isPure
                      ? _passwordValidator.error?.name
                      : null,
            ),
            SizedBox(height: 20),
            PrimaryTextField(
              controller: _confirmPasswordController,
              fieldName: 'Confirm Password',
              obscureText: true,
              errorMessage: !_passwordConfirmationValidator.isValid &&
                      !_passwordConfirmationValidator.isPure
                  ? _passwordConfirmationValidator.error?.name
                  : null,
            ),
            SizedBox(height: 40),
            PrimaryButton.filled(
              text: 'Register',
              onPressed: () {
                _validator();
                _register();
              },
            ),
            SizedBox(height: 20),
            Text(
              'OR',
              style: TextStyle(
                  color: AppPalette.teal,
                  fontSize: 17,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Spacer(),
                CircularShadowButton(
                  offset: Offset(15, 0),
                  iconSize: 30,
                  onPressed: () {},
                  icon: LogoPainter.facebook(),
                ),
                SizedBox(width: 10),
                CircularShadowButton(
                  offset: Offset(12.5, 2),
                  iconSize: 30,
                  onPressed: () {},
                  icon: LogoPainter.google(),
                ),
                Spacer()
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  style: TextStyle(
                    color: AppPalette.teal.withAlpha(150),
                    fontSize: 18,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      color: AppPalette.teal,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
