// // lib/widgets/custom_card.dart
// import 'package:flutter/material.dart';

// class CustomCard extends StatelessWidget {
//   final Widget child;
//   final Color backgroundColor;
//   final double elevation;
//   final BorderRadius borderRadius;

//   const CustomCard({
//     Key? key,
//     required this.child,
//     this.backgroundColor = const Color(0xFFF5EEDC),
//     this.elevation = 0,
//     this.borderRadius = const BorderRadius.all(Radius.circular(15)),
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: backgroundColor,
//       elevation: elevation,
//       shape: RoundedRectangleBorder(borderRadius: borderRadius),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: child,
//       ),
//     );
//   }
// }
// lib/widgets/custom_card.dart
import 'package:flutter/material.dart';
import '../config/app_colors.dart'; // Use AppColors

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap; // Add onTap functionality

  const CustomCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use CardTheme from Theme.of(context) for consistency
    return Card(
      // No need to set color, elevation, shape here if defined in theme
      clipBehavior: Clip.antiAlias, // Ensures content respects rounded corners
      child: InkWell( // Make the card tappable if onTap is provided
        onTap: onTap,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}