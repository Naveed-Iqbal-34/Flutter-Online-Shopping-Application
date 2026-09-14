import 'package:database_in_flutter/widgets/text_button.dart';
import 'package:database_in_flutter/widgets/text_field.dart';
import 'package:database_in_flutter/screens/main_screen.dart';
import 'package:database_in_flutter/screens/singup_screen.dart';
import 'package:database_in_flutter/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:database_in_flutter/widgets/custom_text.dart';
import 'package:database_in_flutter/widgets/elevated_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../providers/auth_provider.dart';

// Ensure this points to the layout shell screen where users land after logging in successfully
// import 'package:database_in_flutter/screens/main_navigation_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. Core State Controllers to capture dynamic text inputs
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool hideTextFieldText = true;

  // 2. State variable to handle the visual check indicator switch
  bool _rememberMe = false;

  @override
  void dispose() {
    // Safely flush text controllers out of device cache memory when leaving screen
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 3. Central Login Authentication & Session Storage Action Routine
  void _executeLogin() async {
    String inputEmail = _emailController.text.trim();
    String inputPassword = _passwordController.text.trim();

    // Baseline verification validation step
    if (inputEmail.isEmpty || inputPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both your email and password.'),
        ),
      );
      return;
    }

    // Fire look up script matching criteria against your local SQLite user table rows
    final authProvider = context.read<AuthProvider>();

    await authProvider.login(
      inputEmail,
      inputPassword,
    );

    final authenticatedUser = authProvider.user;

    if (authenticatedUser != null) {
      // SUCCESS: Access settings profile notes file inside internal device storage
      final persistentStorage = await SharedPreferences.getInstance();

      if (_rememberMe) {
        // If checked, save a permanent boolean flag so the splash screen knows to auto-skip
        await persistentStorage.setBool('remember_me_status', true);
        await persistentStorage.setString('cached_user_email', inputEmail);
      } else {
        // Otherwise explicit reset ensures clean state environment
        await persistentStorage.setBool('remember_me_status', false);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome back, ${authenticatedUser['username']}!'),
          ),
        );


        // Jumps past login gates cleanly and locks target landing display dashboard context
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen()
          ),
        );

      }
    } else {
      // FAILURE ROUTINE: Alert visual error notification banner to user interface layer
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Invalid email credentials or account does not exist.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 60,
            top: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    "Welcome Back",
                    color: Colors.black,
                    size: 32,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.bold,
                  ),
                  CustomText(
                    "Log in to your account ",
                    color: Colors.black,
                    size: 16,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                children: [
                  // 1. YOUR EMAIL FIELD
                  CustomTextField(
                    controller: _emailController,
                    // ◄ CRITICAL UNCOMMENT: Captures email typing inputs!
                    hideText: false,
                    prefixIcon: const Icon(Icons.email_outlined),
                    suffixIconButton: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                      style: const ButtonStyle(),
                    ),
                    hint: 'Enter your Email',
                  ),

                  const SizedBox(height: 11),

                  // 2. YOUR PASSWORD FIELD
                  CustomTextField(
                    controller: _passwordController,
                    // ◄ CRITICAL UNCOMMENT: Captures password typing inputs!
                    hideText: hideTextFieldText,
                    prefixIcon: const Icon(Icons.key),
                    suffixIconButton: IconButton(
                      onPressed: () {
                        setState(() {
                          hideTextFieldText = !hideTextFieldText;
                        });
                      },
                      icon: Icon(
                        hideTextFieldText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                    hint: 'Enter your password',
                  ),

                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // IMPLEMENTED INTERACTIVE CHECKBOX ROW SEGMENT
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            activeColor: ColorsUsed.electricBlue,
                            onChanged: (bool? newValue) {
                              setState(() {
                                _rememberMe = newValue ?? false;
                              });
                            },
                          ),
                          CustomText('Remember me'),
                        ],
                      ),
                      CustomTextButton(
                        name: CustomText(
                          'Forgot Password?',
                          color: ColorsUsed.electricBlue,
                          fontWeight: FontWeight.bold,
                        ),
                        callback: () {},
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: CustomElevatedButton(
                      bgColor: ColorsUsed.electricBlue,
                      name: CustomText(
                        'Log In',
                        size: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      callback:
                          _executeLogin, // Binds your authentication logic directly to layout triggers!
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          "Don't have an account?",
                          color: Colors.black,
                        ),
                        CustomTextButton(
                          name: CustomText(
                            'Sin UP',
                            // Matches your custom spelling target layout text string
                            color: Colors.blue,
                            size: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          callback: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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
