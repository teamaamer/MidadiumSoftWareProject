// // // lib/widgets/filter_chip.dart
// // import 'package:flutter/material.dart';

// // class CustomFilterChip extends StatelessWidget {
// //   final String label;
// //   final bool isSelected;
// //   final VoidCallback onSelected;

// //   const CustomFilterChip({
// //     Key? key,
// //     required this.label,
// //     required this.isSelected,
// //     required this.onSelected,
// //   }) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return FilterChip(
// //       label: Text(
// //         label,
// //         style: TextStyle(
// //           color: isSelected ? Colors.white : const Color(0xFF183B4E),
// //         ),
// //       ),
// //       selected: isSelected,
// //       onSelected: (bool selected) => onSelected(),
// //       selectedColor: const Color(0xFF27548A),
// //       backgroundColor: const Color(0xFFF5EEDC),
// //       checkmarkColor: Colors.white,
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(20),
// //         side: const BorderSide(color: Color(0xFF183B4E)),
// //       ),
// //     );
// //   }
// // }
// // lib/widgets/filter_chip.dart
// import 'package:flutter/material.dart';
// import '../config/app_colors.dart'; // Use AppColors

// class CustomFilterChip extends StatelessWidget {
//   final String label;
//   final bool isSelected;
//   final VoidCallback onSelected;
//   final IconData? icon; // Optional leading icon

//   const CustomFilterChip({
//     Key? key,
//     required this.label,
//     required this.isSelected,
//     required this.onSelected,
//     this.icon,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Uses ChipTheme from Theme.of(context)
//     return FilterChip(
//       label: Text(label), // Style comes from ChipTheme.labelStyle
//       avatar: icon != null ? Icon(icon, size: 16, color: isSelected ? AppColors.textLight : AppColors.textSecondary) : null,
//       selected: isSelected,
//       onSelected: (bool selected) => onSelected(),
//       // Colors, shape, checkmarkColor, padding etc. are handled by ChipTheme
//     );
//   }
// }
// lib/widgets/filter_chip.dart
import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class CustomFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;
  final IconData? icon;

  // Define desired padding directly here
  final EdgeInsetsGeometry padding;
  // Define desired text styles directly here
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;
  final Color? selectedColor;
  final Color? backgroundColor;
  final double? iconSize;

  const CustomFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.icon,
    // Set default padding within the widget
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 9), // Increased padding
    // Set default styles within the widget
    this.selectedLabelStyle = const TextStyle( // Default selected style
      color: AppColors.textLight,
      fontWeight: FontWeight.w600,
      fontSize: 13, // Slightly smaller font size maybe?
    ),
    this.unselectedLabelStyle = const TextStyle( // Default unselected style
       color: AppColors.textPrimary,
       fontSize: 13, // Slightly smaller font size maybe?
    ),
    this.selectedColor = AppColors.primary, // Default selected background
    this.backgroundColor = AppColors.chipBackground, // Default background
    this.iconSize = 16, // Default icon size
  });

  @override
  Widget build(BuildContext context) {
    // No need to get ChipThemeData if overriding everything

    // Determine current styles based on isSelected
    final currentLabelStyle = (isSelected ? selectedLabelStyle : unselectedLabelStyle) ?? AppTextStyles.bodyText2; // Fallback style
    final currentIconColor = currentLabelStyle.color ?? (isSelected ? AppColors.textLight : AppColors.textSecondary);

    return FilterChip(
      showCheckmark: false, // Controlled here
      avatar: icon != null
          ? Icon(
              icon,
              size: iconSize, // Use defined size
              color: currentIconColor, // Use calculated icon color
            )
          : null,
      label: Text(label),
      labelStyle: currentLabelStyle, // Apply calculated style
      selected: isSelected,
      onSelected: (bool selected) => onSelected(),
      backgroundColor: backgroundColor, // Use defined background
      selectedColor: selectedColor, // Use defined selected background
      padding: padding, // Use defined padding
      // Keep shape definition consistent or make it a parameter
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      // Keep conditional border if desired
      side: !isSelected
          ? BorderSide(color: AppColors.divider.withOpacity(0.5), width: 0.5)
          : BorderSide.none, // No border when selected by default
    );
  }
}