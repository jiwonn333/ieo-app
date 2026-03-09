import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('마이페이지')),
      body: const Padding(
        padding: EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('내 프로필과 계정 설정을 관리할 수 있어요.'),
          ],
        ),
      ),
    );
  }
}