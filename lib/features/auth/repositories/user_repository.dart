import '../models/auth_user.dart';

/// 앱 회원 저장소 인터페이스 추가
/// 카카오 로그인 성공과 앱 회원가입 완료는 분리

abstract class UserRepository {
  Future<bool> existsByKakaoId(int kakaoId);

  Future<void> createUser({
    required AuthUser authUser,
    required String appNickname,
  });
}
