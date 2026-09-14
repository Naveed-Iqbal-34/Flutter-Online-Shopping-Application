import 'package:flutter/material.dart';

import 'package:database_in_flutter/custom_widgets/text_button.dart';
import 'package:database_in_flutter/custom_widgets/text_field.dart';
import 'package:database_in_flutter/custom_widgets/custom_text.dart';
import 'package:database_in_flutter/custom_widgets/elevated_button.dart';

import 'package:database_in_flutter/database_helper/database_helper.dart';
import 'package:database_in_flutter/ui_helper/ui_helper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // =========================================
  // CONTROLLERS
  // =========================================

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool hidePassword = true;
  bool hideConfirmPassword = true;

  // =========================================
  // SIGN UP
  // =========================================

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Check empty fields
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields.')));

      return;
    }

    // Check password
    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match.')));

      return;
    }

    // =========================================
    // SAVE USER TO SQLITE
    // =========================================

    final result = await DatabaseHelper.instance.registerUser(email, password);

    if (!mounted) return;

    if (result != -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );

      // Return to Login screen
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This email already exists.')),
      );
    }
  }

  // =========================================
  // DISPOSE
  // =========================================

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  // =========================================
  // BUILD
  // =========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),

        title: const Text(
          'Sign Up',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // =====================================
              // TITLE
              // =====================================
              CustomText(
                'Create Account',
                color: Colors.black,
                size: 30,
                fontWeight: FontWeight.bold,
              ),

              CustomText(
                'Create a new ShopEasy account',
                color: Colors.black54,
                size: 16,
              ),

              const SizedBox(height: 35),

              // =====================================
              // EMAIL
              // =====================================
              CustomTextField(
                controller: _emailController,
                hideText: false,
                prefixIcon: const Icon(Icons.email_outlined),
                hint: 'Enter your Email',
                suffixIconButton: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.edit),
                ),
              ),

              const SizedBox(height: 12),

              // =====================================
              // PASSWORD
              // =====================================
              CustomTextField(
                controller: _passwordController,
                hideText: hidePassword,

                prefixIcon: const Icon(Icons.key),

                suffixIconButton: IconButton(
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },

                  icon: Icon(
                    hidePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),

                hint: 'Enter your Password',
              ),

              const SizedBox(height: 12),

              // =====================================
              // CONFIRM PASSWORD
              // =====================================
              CustomTextField(
                controller: _confirmPasswordController,

                hideText: hideConfirmPassword,

                prefixIcon: const Icon(Icons.lock_outline),

                suffixIconButton: IconButton(
                  onPressed: () {
                    setState(() {
                      hideConfirmPassword = !hideConfirmPassword;
                    });
                  },

                  icon: Icon(
                    hideConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),

                hint: 'Confirm Password',
              ),

              const SizedBox(height: 30),

              // =====================================
              // SIGN UP BUTTON
              // =====================================
              SizedBox(
                width: double.infinity,

                child: CustomElevatedButton(
                  bgColor: ColorsUsed.electricBlue,

                  name: CustomText(
                    'Sign Up',
                    size: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),

                  callback: _signUp,
                ),
              ),

              const SizedBox(height: 15),

              // =====================================
              // LOGIN LINK
              // =====================================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  CustomText('Already have an account?', color: Colors.black),

                  CustomTextButton(
                    name: CustomText(
                      'Log In',
                      color: Colors.blue,
                      size: 16,
                      fontWeight: FontWeight.bold,
                    ),

                    callback: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
