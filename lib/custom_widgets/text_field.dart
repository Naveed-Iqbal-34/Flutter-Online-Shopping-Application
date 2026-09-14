import 'package:flutter/material.dart';
import 'package:database_in_flutter/ui_helper/ui_helper.dart';

class CustomTextField extends StatelessWidget {
  final bool hideText;
  final Widget prefixIcon;
  final Widget suffixIconButton;
  final String hint;
  final TextEditingController? controller; // ADDED: Accepts a controller from the parent screen

  const CustomTextField({
    required this.hideText,
    required this.prefixIcon,
    required this.suffixIconButton,
    required this.hint,
    this.controller, //  ADDED: Optional controller declaration parameter
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller, // CRITICAL: Binds Flutter's native engine to your text controller
      obscureText: hideText,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIconButton,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: ColorsUsed.electricBlue, width: 2.0),
        ),
      ),
    );
  }
}
