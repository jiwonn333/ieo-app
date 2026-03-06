import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text(
                'IEO',
                style: textTheme.headlineLarge,
              ),
              const SizedBox(height: 12),
              Text(
                '진짜 인연을 잇다',
                style: textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                '하루 5명의 추천 매칭으로\n가볍지 않은 진지한 만남을 시작해보세요.',
                style: textTheme.bodyLarge,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('시작하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}