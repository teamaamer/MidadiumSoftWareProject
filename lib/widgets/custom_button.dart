// // lib/widgets/custom_button.dart
// import 'package:flutter/material.dart';

// class CustomButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;
//   final Color backgroundColor;
//   final Color textColor;
//   final BorderRadius borderRadius;

//   const CustomButton({
//     Key? key,
//     required this.text,
//     required this.onPressed,
//     this.backgroundColor = const Color(0xFF27548A),
//     this.textColor = Colors.white,
//     this.borderRadius = const BorderRadius.all(Radius.circular(12)),
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: backgroundColor,
//         foregroundColor: textColor,
//         shape: RoundedRectangleBorder(borderRadius: borderRadius),
//         padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(fontSize: 16, color: textColor),
//       ),
//     );
//   }
// }

// lib/widgets/custom_button.dart
import 'package:flutter/material.dart';
import '../config/app_colors.dart'; // Use AppColors
import '../config/app_text_styles.dart'; // Use AppTextStyles

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor; // Allow overriding theme color
  final Color? textColor;       // Allow overriding theme text color
  final IconData? icon;        // Add optional icon
  final double? elevation;
  final OutlinedBorder? shape;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.elevation,
    this.shape,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor, // Will use theme if null
        foregroundColor: textColor,       // Will use theme if null
        elevation: elevation,           // Will use theme if null
        shape: shape,                   // Will use theme if null
        // Padding is handled by theme, but can be overridden if needed:
        // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Don't take full width unless needed
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18), // Adjust icon size as needed
            const SizedBox(width: 8),
          ],
          Text(text), // Text style comes from theme
        ],
      ),
    );
  }
}