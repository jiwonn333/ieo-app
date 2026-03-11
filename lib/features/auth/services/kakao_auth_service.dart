import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../models/auth_user.dart';

class KakaoLoginCanceledException implements Exception {
  final String message;

  KakaoLoginCanceledException([this.message = '사용자가 로그인을 취소했어요.']);

  @override
  String toString() => message;
}

class KakaoAuthService {
  Future<AuthUser> signIn() async {
    try {
      debugPrint('[KAKAO LOGIN] signIn 진입');

      final installed = await isKakaoTalkInstalled();
      debugPrint('[KAKAO LOGIN] 카카오톡 설치 여부: $installed');

      if (installed) {
        try {
          debugPrint('[KAKAO LOGIN] loginWithKakaoTalk 호출 전');
          await UserApi.instance.loginWithKakaoTalk();
          debugPrint('[KAKAO LOGIN] loginWithKakaoTalk 성공');
        } catch (e) {
          debugPrint('[KAKAO LOGIN] loginWithKakaoTalk 실패: $e');

          if (_isUserCanceled(e)) {
            throw KakaoLoginCanceledException();
          }

          debugPrint('[KAKAO LOGIN] loginWithKakaoAccount 재시도');
          await UserApi.instance.loginWithKakaoAccount();
          debugPrint('[KAKAO LOGIN] loginWithKakaoAccount 성공');
        }
      } else {
        try {
          debugPrint('[KAKAO LOGIN] loginWithKakaoAccount 호출 전');
          await UserApi.instance.loginWithKakaoAccount();
          debugPrint('[KAKAO LOGIN] loginWithKakaoAccount 성공');
        } catch (e) {
          if (_isUserCanceled(e)) {
            throw KakaoLoginCanceledException();
          }
          rethrow;
        }
      }

      debugPrint('[KAKAO LOGIN] me 호출 전');
      final user = await UserApi.instance.me();
      debugPrint('[KAKAO LOGIN] me 호출 성공');

      final kakaoId = user.id;
      if (kakaoId == null) {
        throw Exception('카카오 사용자 정보를 불러오지 못했어요.');
      }

      final account = user.kakaoAccount;
      final nickname = account?.profile?.nickname;
      final name = _normalize(account?.name);

      final birthYear = _normalize(account?.birthyear);
      final birthday = _normalize(account?.birthday);
      final birthDate = _parseBirthDate(
        birthYear: birthYear,
        birthday: birthday,
      );

      final gender = AuthGender.fromCode(account?.gender?.name);

      debugPrint('[KAKAO LOGIN] kakaoId: $kakaoId');
      debugPrint('[KAKAO LOGIN] nickname: $nickname');
      debugPrint('[KAKAO LOGIN] name: $name');
      debugPrint('[KAKAO LOGIN] birthYear: $birthYear');
      debugPrint('[KAKAO LOGIN] birthday: $birthday');
      debugPrint('[KAKAO LOGIN] gender: ${gender?.code}');

      return AuthUser(
        kakaoId: kakaoId,
        nickname: _normalize(nickname),
        name: name,
        birthDate: birthDate,
        gender: gender,
      );
    } on KakaoLoginCanceledException {
      rethrow;
    } catch (e, st) {
      debugPrint('[KAKAO LOGIN] 에러: $e');
      debugPrint('$st');
      throw Exception('카카오 로그인 중 오류가 발생했어요.');
    }
  }

  String? _normalize(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  DateTime? _parseBirthDate({
    required String? birthYear,
    required String? birthday,
  }) {
    if (birthYear == null || birthday == null) return null;
    if (birthday.length != 4) return null;

    final year = int.tryParse(birthYear);
    final month = int.tryParse(birthday.substring(0, 2));
    final day = int.tryParse(birthday.substring(2, 4));

    if (year == null || month == null || day == null) return null;

    final parsed = DateTime(year, month, day);

    if (parsed.year != year || parsed.month != month || parsed.day != day) {
      return null;
    }

    return parsed;
  }

  bool _isUserCanceled(Object error) {
    final message = error.toString().toLowerCase();
    return message.contains('cancel') ||
        message.contains('canceled') ||
        message.contains('cancelled');
  }
}
