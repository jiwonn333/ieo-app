import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      badge: '진지한 인연',
      title: '가볍지 않은 만남,\n이제는 기준 있게',
      description:
      '무한 스와이프 대신, 하루 5명의 엄선된 추천으로\n더 진지한 만남을 시작해보세요.',
      icon: Icons.all_inclusive_rounded,
    ),
    _OnboardingData(
      badge: '안전한 만남',
      title: '신뢰할 수 있는 정보로\n더 안심되는 연결',
      description:
      '프로필과 소개 정보를 바탕으로\n더 믿을 수 있는 만남을 경험해보세요.',
      icon: Icons.verified_user_rounded,
    ),
    _OnboardingData(
      badge: '함께하는 미래',
      title: '진짜 인연을 만나는\n첫걸음을 시작하세요',
      description:
      '이어는 가벼운 만남보다 오래 이어질 관계를 원하는\n사람들을 위한 서비스입니다.',
      icon: Icons.favorite_outline_rounded,
      highlightText: '여성 회원 가입 시 3개월 프리미엄 무료',
    ),
  ];

  bool get _isLast => _currentIndex == _pages.length - 1;

  void _goLogin() {
    context.go('/login');
  }

  void _next() {
    if (_isLast) {
      _goLogin();
      return;
    }

    _controller.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCF8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _goLogin,
                  child: Text(
                    '건너뛰기',
                    style: AppTextStyles.titleMedium
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ),

              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (i) {
                    setState(() {
                      _currentIndex = i;
                    });
                  },
                  itemBuilder: (_, index) {
                    return _OnboardingPage(
                      data: _pages[index],
                      isActive: index == _currentIndex,
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              _PageIndicator(
                count: _pages.length,
                currentIndex: _currentIndex,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: FilledButton(
                  onPressed: _next,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    _isLast ? '지금 시작하기' : '다음',
                    style: AppTextStyles.labelLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.data,
    required this.isActive,
  });

  final _OnboardingData data;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
      opacity: isActive ? 1 : 0.65,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: Column(
          children: [
            AnimatedSlide(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              offset: isActive ? Offset.zero : const Offset(0, 0.04),
              child: Text(
                '이어 IEO',
                style: AppTextStyles.headlineLarge.copyWith(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),

            const SizedBox(height: 40),

            AnimatedScale(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutBack,
              scale: isActive ? 1.0 : 0.88,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFFF7F1E3)
                      : const Color(0xFFF9F5EC),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: isActive
                      ? const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 18,
                      offset: Offset(0, 10),
                    ),
                  ]
                      : [],
                ),
                child: Center(
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    scale: isActive ? 1.0 : 0.9,
                    child: Icon(
                      data.icon,
                      size: 70,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            AnimatedOpacity(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOut,
              opacity: isActive ? 1 : 0.75,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6EED8),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  data.badge,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 26),

            AnimatedSlide(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              offset: isActive ? Offset.zero : const Offset(0, 0.03),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 240),
                opacity: isActive ? 1 : 0.7,
                child: Text(
                  data.title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headlineMedium,
                ),
              ),
            ),

            const SizedBox(height: 18),

            AnimatedOpacity(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOut,
              opacity: isActive ? 1 : 0.72,
              child: Text(
                data.description,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
              ),
            ),

            if (data.highlightText != null) ...[
              const SizedBox(height: 26),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOut,
                opacity: isActive ? 1 : 0.8,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOut,
                  scale: isActive ? 1 : 0.96,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7EFD9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '🎁 ${data.highlightText!}',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.count,
    required this.currentIndex,
  });

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
            (index) {
          final active = index == currentIndex;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: active ? 32 : 10,
            height: 10,
            decoration: BoxDecoration(
              color: active
                  ? AppColors.primary
                  : AppColors.textSecondary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }
}

class _OnboardingData {
  final String badge;
  final String title;
  final String description;
  final IconData icon;
  final String? highlightText;

  const _OnboardingData({
    required this.badge,
    required this.title,
    required this.description,
    required this.icon,
    this.highlightText,
  });
}