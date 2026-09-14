import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final String fontFamily;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final int? maxLines;

  const CustomText(
      this.text, { // The actual text string is required first
        this.size = 14.0, // Default fallback text size
        this.color = Colors.black, // Default fallback color
        this.fontFamily = 'Inter', // Default brand font family
        this.fontWeight = FontWeight.normal, // Default weight
        this.textAlign = TextAlign.left, // Default paragraph alignment
        this.maxLines,
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontSize: size,
        color: color,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
      ),
    );
  }
}
