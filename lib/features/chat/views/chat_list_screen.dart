import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('채팅')),
      body: const Padding(
        padding: EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('매칭된 상대와 대화를 시작해보세요.'),
          ],
        ),
      ),
    );
  }
}