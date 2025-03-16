
import 'package:fili_money/registration/registration_screen.dart';
import 'package:fili_money/validation/email_validation.dart';
import 'package:fili_money/validation/password_validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:fili_money/theme/color.dart';
import 'package:fili_money/widget/buttons/circular_buttons.dart';
import 'package:fili_money/widget/buttons/primary_button.dart';
import 'package:fili_money/widget/logo/logo_painter.dart';
import 'package:fili_money/widget/text_fields/primary_textfield.dart';

import '../widget/navbar/nav_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  late EmailValidator _emailValidator;
  late PasswordValidator _passwordValidator;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailValidator = EmailValidator.pure();
    _passwordValidator = PasswordValidator.pure();
  }

  Future<void> _loginWithEmail() async {
    if (!_emailValidator.isValid || !_passwordValidator.isValid) {
      return;
    }
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Handle successful login
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavBarMenu()),
        );
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Error: ${e.code} $e');

      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage =
              'The user corresponding to the given email has been disabled.';
          break;
        case 'user-not-found':
          errorMessage = 'There is no user corresponding to the given email.';
          break;
        case 'wrong-password':
          errorMessage = 'The password is invalid for the given email.';
          break;
        case 'no-user':
          errorMessage = 'No user found with the given credentials.';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid Email or Password.';
          break;
        default:
          errorMessage = 'An unknown error occurred.';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: TextStyle(color: Colors.red.shade200),
            ),
          ),
        );
      }
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      // Handle successful login
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavBarMenu()),
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'An error occurred while signing in with Google',
              style: TextStyle(color: Colors.red),
            ),
          ),
        );
      }
    }
  }

  void _validator() {
    setState(() {
      _emailValidator = EmailValidator.dirty(_emailController.text);
      _passwordValidator = PasswordValidator.dirty(_passwordController.text);

      debugPrint('Email: ${_emailValidator.error?.name}');
      debugPrint('Password: ${_passwordValidator.error?.name}');
    });
  }

  void _forgotPasswordValidator() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.message ?? 'An error occurred',
              style: TextStyle(color: Colors.red),
            ),
          ),
        );
      }
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                e.message ?? 'An error occurred',
                style: TextStyle(color: Colors.red),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome',
                    style: TextStyle(
                      color: AppPalette.teal,
                      fontWeight: FontWeight.w500,
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    'Sign In',
                    style: TextStyle(
                      color: AppPalette.teal,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 60),
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
              errorMessage:
                  !_passwordValidator.isValid && !_passwordValidator.isPure
                      ? _passwordValidator.error?.name
                      : null,
              obscureText: true,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _forgotPasswordValidator,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: AppPalette.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            PrimaryButton.filled(
              text: 'Login',
              onPressed: () {
                _validator();
                _loginWithEmail();
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(width: 10),
                CircularShadowButton(
                  offset: Offset(12.5, 2),
                  iconSize: 30,
                  onPressed: _loginWithGoogle,
                  icon: LogoPainter.google(),
                ),
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account?',
                  style: TextStyle(
                    color: AppPalette.teal.withAlpha(150),
                    fontSize: 18,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: AppPalette.teal,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          ],
        ),
      ),
    );
  }
}
