// lib/widgets/status_chip.dart
import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class StatusChip extends StatelessWidget {
  final bool isActive;

  const StatusChip({Key? key, required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = isActive ? AppColors.success : AppColors.error;
    final IconData icon = isActive ? Icons.check_circle_outline : Icons.cancel_outlined;
    final String label = isActive ? 'Active' : 'Inactive';

    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
      backgroundColor: color.withOpacity(0.15),
      visualDensity: VisualDensity.compact, // Make chip smaller
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      side: BorderSide.none, // Remove border from default chip theme
    );
  }
}