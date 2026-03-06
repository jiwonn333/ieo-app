import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: '휴대폰 번호',
                hintText: '01012345678',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: () => context.go('/match'),
                child: const Text('인증하고 시작하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}