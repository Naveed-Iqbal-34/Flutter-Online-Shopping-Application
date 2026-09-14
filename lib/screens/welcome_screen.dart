import 'package:database_in_flutter/custom_widgets/text_button.dart';
import 'package:database_in_flutter/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:database_in_flutter/custom_widgets/custom_text.dart';
import 'package:database_in_flutter/custom_widgets/elevated_button.dart';
import 'package:database_in_flutter/ui_helper/ui_helper.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. THE MAIN GRADIENT LAYER
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorsUsed.electricBlue, // Bright Electric Blue at top
                  ColorsUsed.navyBlue // Deep Navy Blue at bottom
                ],
              ),
            ),
          ),

          // 2. THE CUSTOM FIGMA WAVY ASSET LAYER
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/welcome_waves.png',
              // exported transparent Figma wave
              fit: BoxFit.cover,
            ),
          ),

          // 3. YOUR CONTENT OVERLAY LAYER
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 60,
                top: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Image.asset('assets/images/logoW.png'),
                      CustomText(
                        "Your Favorite Products At Your Fingertips",
                        color: Colors.white,
                        size: 20,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: CustomElevatedButton(
                          name: CustomText(
                            'Get Start',
                            size: 20,
                            color: Color(0xFF437FFF),
                            fontWeight: FontWeight.bold,
                          ),
                          callback: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              "Already have an account?",
                              color: Colors.white,
                            ),
                            CustomTextButton(
                              name: CustomText(
                                'Log In',
                                color: Colors.white,
                                size: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              callback: () {},
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
        ],
      ),
    );
  }
}
