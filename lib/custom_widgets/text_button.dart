import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final Widget name;
  final Color? textColor;
  final double? fontSize;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  final VoidCallback? callback;
  const CustomTextButton(
      {
        super.key,
        this.iconSize,
        required this.name,
        this.fontSize,
        this.textColor,
        this.icon,
        this.iconColor,
        required this. callback
      }
      );

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        return callback!();
      },
      child:icon!=null? Column(
        children: [
          Icon( icon, size: iconSize, color: iconColor),
          name
        ],
      ):
      name
    );
  }
}
