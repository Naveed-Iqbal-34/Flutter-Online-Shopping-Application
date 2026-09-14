import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'welcome_screen.dart';
import 'main_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
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
    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();

    final rememberMe =
        prefs.getBool('remember_me_status') ?? false;

    if (!rememberMe) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        ),
      );
      return;
    }

    final savedEmail =
    prefs.getString('cached_user_email');

    if (savedEmail == null || savedEmail.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        ),
      );
      return;
    }

    final restored = await context
        .read<AuthProvider>()
        .restoreUser(savedEmail);

    if (!mounted) return;

    if (restored) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    } else {
      await prefs.setBool('remember_me_status', false);

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