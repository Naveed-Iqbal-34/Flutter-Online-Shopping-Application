import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'welcome_screen.dart';
import 'main_screen.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    _checkRememberMe();
  }

  Future<void> _checkRememberMe() async {

    // Wait 5 seconds for splash screen
    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;

    // Get saved login information
    final prefs = await SharedPreferences.getInstance();

    final rememberMe =
        prefs.getBool('remember_me_status') ?? false;

    if (!mounted) return;

    if (rememberMe) {

      // Remember Me was checked
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => HomeProvider(),
            child: const MainScreen(),
          ),
        ),
      );

    } else {

      // Remember Me was not checked
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
        ),
      ),
    );
  }
}