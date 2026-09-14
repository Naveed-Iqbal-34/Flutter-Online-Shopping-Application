import 'package:database_in_flutter/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:database_in_flutter/screens/splash_screen.dart';
import 'package:database_in_flutter/providers/cart_provider.dart';
import 'package:database_in_flutter/providers/product_provider.dart';

void main() {
  runApp(const ShopEasy());
}

class ShopEasy extends StatelessWidget {
  const ShopEasy({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "ShopEasy",
        home: const SplashScreen(),
      ),
    );
  }
}