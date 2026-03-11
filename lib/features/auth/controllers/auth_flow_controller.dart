import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/auth_user.dart';
import '../providers/auth_providers.dart';
import '../services/kakao_auth_service.dart';
import '../utils/signup_age_policy.dart';

enum AuthFlowStatus {
  idle,
  loading,
  existingUser,
  newUser,
  ineligible,
  canceled,
  error,
}

class AuthFlowState {
  final AuthFlowStatus status;
  final AuthUser? user;
  final String? message;

  const AuthFlowState({required this.status, this.user, this.message});

  factory AuthFlowState.idle() {
    return const AuthFlowState(status: AuthFlowStatus.idle);
  }
}

class AuthFlowResult {
  final AuthFlowStatus status;
  final AuthUser? user;
  final String? message;

  const AuthFlowResult({required this.status, this.user, this.message});
}

class AuthFlowController extends AutoDisposeNotifier<AuthFlowState> {
  @override
  AuthFlowState build() {
    return AuthFlowState.idle();
  }

  Future<AuthFlowResult> loginWithKakao() async {
    if (state.status == AuthFlowStatus.loading) {
      return const AuthFlowResult(status: AuthFlowStatus.loading);
    }

    debugPrint('[AUTH FLOW] loading 시작');
    state = const AuthFlowState(status: AuthFlowStatus.loading);

    try {
      final authService = ref.read(kakaoAuthServiceProvider);
      final userRepository = ref.read(userRepositoryProvider);

      final user = await authService.signIn();
      debugPrint('[AUTH FLOW] signIn 성공: ${user.kakaoId}');

      if (user.gender != null && user.birthDate != null) {
        final eligible = isEligibleForSignup(
          gender: user.gender!,
          birthDate: user.birthDate!,
        );

        if (!eligible) {
          debugPrint('[AUTH FLOW] 가입 조건 미충족');

          final result = AuthFlowResult(
            status: AuthFlowStatus.ineligible,
            user: user,
            message: getSignupIneligibleMessage(user.gender!),
          );

          state = AuthFlowState.idle();
          return result;
        }
      }

      final isRegistered = await userRepository.existsByKakaoId(user.kakaoId);
      debugPrint('[AUTH FLOW] existsByKakaoId=$isRegistered');

      final result = AuthFlowResult(
        status: isRegistered
            ? AuthFlowStatus.existingUser
            : AuthFlowStatus.newUser,
        user: user,
      );

      debugPrint('[AUTH FLOW] 최종 상태=${result.status}');
      state = AuthFlowState.idle();
      return result;
    } on KakaoLoginCanceledException catch (e) {
      debugPrint('[AUTH FLOW] 취소: $e');
      state = AuthFlowState.idle();

      return AuthFlowResult(
        status: AuthFlowStatus.canceled,
        message: e.toString(),
      );
    } catch (e) {
      debugPrint('[AUTH FLOW] 에러: $e');
      state = AuthFlowState.idle();

      return AuthFlowResult(
        status: AuthFlowStatus.error,
        message: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
}
