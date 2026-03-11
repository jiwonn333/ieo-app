import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/auth_flow_controller.dart';
import '../models/signup_step.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_header.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  Future<void> _handleKakaoLogin() async {
    if (ref.read(authFlowControllerProvider).status == AuthFlowStatus.loading) {
      return;
    }

    final controller = ref.read(authFlowControllerProvider.notifier);
    final result = await controller.loginWithKakao();

    debugPrint('[LOGIN] result.status=${result.status}');
    debugPrint('[LOGIN] result.user=${result.user?.kakaoId}');

    if (!mounted) return;

    switch (result.status) {
      case AuthFlowStatus.existingUser:
        debugPrint('[LOGIN] 기존 유저 -> /match');

        await ref.read(signupFlowRepositoryProvider).clear();

        if (!mounted) return;
        context.go('/match');
        return;

      case AuthFlowStatus.newUser:
        debugPrint('[LOGIN] 신규 유저 -> /identity-confirm');

        if (result.user != null) {
          await ref
              .read(signupFlowRepositoryProvider)
              .saveStep(SignupStep.identityConfirm);

          if (!mounted) return;
          context.go('/identity-confirm', extra: result.user);
        }
        return;

      case AuthFlowStatus.ineligible:
        await showDialog<void>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('가입 조건 미충족'),
            content: Text(result.message ?? '가입 조건을 확인해주세요.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          ),
        );
        return;

      case AuthFlowStatus.error:
        await showDialog<void>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('로그인 실패'),
            content: Text(result.message ?? '카카오 로그인 중 문제가 발생했어요.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          ),
        );
        return;

      case AuthFlowStatus.canceled:
        debugPrint('[LOGIN] 사용자가 로그인 취소');
        return;

      case AuthFlowStatus.loading:
      case AuthFlowStatus.idle:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authFlowControllerProvider);
    final isLoading = state.status == AuthFlowStatus.loading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthHeader(progress: 0.33),
              const SizedBox(height: 44),
              Text(
                '인연에도 기준이 필요합니다',
                style: AppTextStyles.headlineLarge.copyWith(height: 1.3),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                '이어는 신뢰 기반 매칭을 위해\n이름, 생년월일, 성별 정보를 확인합니다.',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 36),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(color: AppColors.borderStrong),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    _BrandIdentityTile(
                      icon: Icons.verified_user_outlined,
                      title: '실명 기반 시작',
                      description: '가벼운 가입보다 신뢰를 우선합니다',
                    ),
                    SizedBox(height: AppSpacing.lg),
                    _BrandIdentityTile(
                      icon: Icons.cake_outlined,
                      title: '정확한 연령 확인',
                      description: '매칭 신뢰도를 높이는 기본 정보 확인',
                    ),
                    SizedBox(height: AppSpacing.lg),
                    _BrandIdentityTile(
                      icon: Icons.favorite_border,
                      title: '진지한 인연 중심',
                      description: '가벼운 스와이프보다 관계의 시작에 집중합니다',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleKakaoLogin,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFFFEE500),
                    foregroundColor: const Color(0xFF191919),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                  ),
                  child: isLoading
                      ? Text(
                          '불러오는 중...',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: const Color(0xFF191919),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.chat_bubble, size: 20),
                            const SizedBox(width: AppSpacing.md),
                            Text(
                              '카카오로 시작하기',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: const Color(0xFF191919),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandIdentityTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _BrandIdentityTile({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8EA),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Icon(icon, color: AppColors.primaryDark),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                description,
                style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
