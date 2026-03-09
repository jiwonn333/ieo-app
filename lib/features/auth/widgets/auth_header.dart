import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AuthHeader extends StatelessWidget {
  final double progress;
  final bool showBackButton;
  final VoidCallback? onBack;

  const AuthHeader({
    super.key,
    required this.progress,
    this.showBackButton = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    const double leadingSize = 24;
    const double leadingGap = AppSpacing.md;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: leadingSize,
              height: leadingSize,
              child: showBackButton
                  ? IconButton(
                onPressed: onBack ??
                        () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/login');
                      }
                    },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                ),
              )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(width: leadingGap),
            Text(
              '이어',
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'IEO',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: AppColors.border,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }
}