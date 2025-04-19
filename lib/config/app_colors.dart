// lib/config/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF27548A);    // Dark Blue
  static const Color secondary = Color(0xFF183B4E);  // Dark Teal
  static const Color accent = Color.fromARGB(255, 202, 174, 131);     // Golden Yellow
  static const Color background = Color(0xFFE1E6EB); // Light Beige
  static const Color cardBackground = Color(0xFFFFFFFF); // White for cards
  static const Color appBarBackground = Color(0xFFFFFFFF); // Explicit AppBar color
  static const Color textPrimary = Color(0xFF183B4E); // Dark Teal for text
  static const Color textSecondary = Color(0xFF5A788A); // Lighter Blue/Grey
  static const Color textLight = Color(0xFFFFFFFF);   // White text
  static const Color error = Color(0xFFD32F2F);      // Standard Red
  static const Color success = Color(0xFF388E3C);     // Standard Green
  static const Color pending = Color(0xFFFFA000);     // Amber/Orange
  static const Color approved = Color(0xFF388E3C);    // Green
  static const Color rejected = Color(0xFFD32F2F);     // Red
 
  static const Color warning = Color(0xFFFFA000);     // Amber/Orange (Same as pending, or choose another like Colors.orange)

  static const Color info = Color(0xFF1976D2);      // Standard Blue (For info messages)
  static const Color shadow = Color(0x33183B4E);     // Subtle shadow using secondary color
  static const Color iconColor = Color(0xFFDDA853);    // Accent color for icons
 static const Color chipBackground = Color(0xFFD0D8E0); // Adjusted chip bg
  static const Color appBarForeground = Color(0xFF183B4E); // Dark text on light AppBar
  static const Color divider = Color(0xFFCFD8DC); // Subtle divider color
  }
