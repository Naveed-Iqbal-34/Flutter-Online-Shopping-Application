import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/main_screen.dart';
class AppPopScope extends StatelessWidget {
  final Widget child;
  final bool goToMainScreen;

  const AppPopScope({
    super.key,
    required this.child,
    this.goToMainScreen = true,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (goToMainScreen) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
                (route) => false,
          );
        } else {
          _showExitDialog(context);
        }
      },
      child: child,
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 10),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

          title: Row(
            children: [
              Icon(
                Icons.exit_to_app_outlined,
                color: Colors.blue,
                size: 28,
              ),

              const SizedBox(width: 12),

              const Text(
                'Exit App',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          content: const Text(
            'Are you sure you want to close the app?',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 11,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Exit',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}