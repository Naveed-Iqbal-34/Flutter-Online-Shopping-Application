import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final Widget name;
  final Color? textColor;
  final double? fontSize;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  final Color? bgColor;
  final double? borderWidth;
  final VoidCallback callback;
  const CustomElevatedButton(
      {
        super.key,
        this.iconSize,
        required this.name,
        this.fontSize,
        this.textColor,
        this.icon,
        this.iconColor,
        this.bgColor,
        this.borderWidth,
        required this.callback
      }
      );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: callback,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: Size.zero,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        )
      ),
        child:icon!=null? Row(
          children: [
            Icon( icon, size: iconSize, color: iconColor),
            name
          ],
        ):
        name
    );
  }
}
