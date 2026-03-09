import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('인증 관리')),
      body: const Padding(
        padding: EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('인증할수록 매칭 우선순위가 높아져요.'),
          ],
        ),
      ),
    );
  }
}