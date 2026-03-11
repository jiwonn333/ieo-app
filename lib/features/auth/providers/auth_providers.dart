import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth_flow_controller.dart';
import '../repositories/local_signup_flow_repository.dart';
import '../repositories/mock_user_repository.dart';
import '../repositories/signup_flow_repository.dart';
import '../repositories/user_repository.dart';
import '../services/kakao_auth_service.dart';

final kakaoAuthServiceProvider = Provider<KakaoAuthService>((ref) {
  return KakaoAuthService();
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return MockUserRepository();
});

final signupFlowRepositoryProvider = Provider<SignupFlowRepository>((ref) {
  return LocalSignupFlowRepository();
});

final authFlowControllerProvider =
    AutoDisposeNotifierProvider<AuthFlowController, AuthFlowState>(
      AuthFlowController.new,
    );
