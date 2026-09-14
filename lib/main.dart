import 'package:flutter/material.dart';
import 'package:database_in_flutter/screens/splash_screen.dart';

void main() {
  runApp(const ShopEasy());
}

class ShopEasy extends StatelessWidget {
  const ShopEasy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ShopEasy",
      home: const SplashScreen(),
    );
  }
}