import 'package:flutter/material.dart';

import '../../core/constants/app_radius.dart';
import '../../core/theme/app_colors.dart';

class IeoFilledButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double height;

  const IeoFilledButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 54,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          gradient: onPressed == null
              ? null
              : const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
          color: onPressed == null ? AppColors.border : null,
        ),
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
