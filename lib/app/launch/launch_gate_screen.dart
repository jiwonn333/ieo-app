import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../../features/auth/models/auth_user.dart';
import '../../features/auth/models/signup_step.dart';
import '../../features/auth/providers/auth_providers.dart';

class LaunchGateScreen extends ConsumerStatefulWidget {
  const LaunchGateScreen({super.key});

  @override
  ConsumerState<LaunchGateScreen> createState() => _LaunchGateScreenState();
}

class _LaunchGateScreenState extends ConsumerState<LaunchGateScreen> {
  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    final signupFlowRepository = ref.read(signupFlowRepositoryProvider);
    final userRepository = ref.read(userRepositoryProvider);

    try {
      final token = await TokenManagerProvider.instance.manager.getToken();
      final hasToken = token != null;
      final signupStep = await signupFlowRepository.getStep();

      debugPrint('[LAUNCH] hasToken=$hasToken');
      debugPrint('[LAUNCH] signupStep=$signupStep');

      if (!hasToken) {
        if (!mounted) return;

        switch (signupStep) {
          case SignupStep.login:
            context.go('/login');
            return;
          case SignupStep.identityConfirm:
            context.go('/login');
            return;
          case SignupStep.onboarding:
          case null:
            context.go('/onboarding');
            return;
        }
      }

      final restoredUser = await _restoreAuthUser();
      if (restoredUser == null) {
        await signupFlowRepository.clear();
        if (!mounted) return;
        context.go('/onboarding');
        return;
      }

      final isRegistered = await userRepository.existsByKakaoId(
        restoredUser.kakaoId,
      );

      debugPrint('[LAUNCH] isRegistered=$isRegistered');

      if (!mounted) return;

      if (isRegistered) {
        await signupFlowRepository.clear();
        context.go('/match');
        return;
      }

      switch (signupStep) {
        case SignupStep.identityConfirm:
          context.go('/identity-confirm', extra: restoredUser);
          return;

        case SignupStep.login:
          context.go('/login');
          return;

        case SignupStep.onboarding:
        case null:
          context.go('/onboarding');
          return;
      }
    } catch (e) {
      debugPrint('[LAUNCH] error=$e');
      await ref.read(signupFlowRepositoryProvider).clear();

      if (!mounted) return;
      context.go('/onboarding');
    }
  }

  Future<AuthUser?> _restoreAuthUser() async {
    try {
      final user = await UserApi.instance.me();
      final kakaoId = user.id;
      if (kakaoId == null) return null;

      return AuthUser(
        kakaoId: kakaoId,
        nickname: user.kakaoAccount?.profile?.nickname,
        name: user.kakaoAccount?.name,
        birthDate: null,
        gender: null,
      );
    } catch (e) {
      debugPrint('[LAUNCH] restore user failed: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
