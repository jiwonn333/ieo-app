import 'dart:async';

import '../models/auth_user.dart';
import 'user_repository.dart';

class MockUserRepository implements UserRepository {
  final Set<int> _registeredIds = <int>{};
  final Map<int, Map<String, dynamic>> _fakeDb = <int, Map<String, dynamic>>{};

  @override
  Future<bool> existsByKakaoId(int kakaoId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _registeredIds.contains(kakaoId);
  }

  @override
  Future<void> createUser({
    required AuthUser authUser,
    required String appNickname,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    _registeredIds.add(authUser.kakaoId);
    _fakeDb[authUser.kakaoId] = {
      'kakaoId': authUser.kakaoId,
      'nickname': appNickname,
      'kakaoNickname': authUser.nickname,
      'name': authUser.name,
      'birthDate': authUser.birthDateText,
      'gender': authUser.genderCode,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}