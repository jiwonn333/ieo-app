enum AuthGender {
  male,
  female;

  String get code {
    switch (this) {
      case AuthGender.male:
        return 'male';
      case AuthGender.female:
        return 'female';
    }
  }

  String get ko {
    switch (this) {
      case AuthGender.male:
        return '남성';
      case AuthGender.female:
        return '여성';
    }
  }

  static AuthGender? fromCode(String? value) {
    switch (value) {
      case 'male':
        return AuthGender.male;
      case 'female':
        return AuthGender.female;
      default:
        return null;
    }
  }
}

class AuthUser {
  final int kakaoId;
  final String? nickname;
  final String? name;
  final DateTime? birthDate;
  final AuthGender? gender;

  const AuthUser({
    required this.kakaoId,
    this.nickname,
    this.name,
    this.birthDate,
    this.gender,
  });

  String get displayName {
    final trimmedName = name?.trim();
    if (trimmedName != null && trimmedName.isNotEmpty) {
      return trimmedName;
    }

    final trimmedNickname = nickname?.trim();
    if (trimmedNickname != null && trimmedNickname.isNotEmpty) {
      return trimmedNickname;
    }

    return '';
  }

  String? get birthDateText {
    final date = birthDate;
    if (date == null) return null;

    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y$m$d';
  }

  String? get genderCode => gender?.code;
  String? get genderKo => gender?.ko;

  AuthUser copyWith({
    int? kakaoId,
    String? nickname,
    String? name,
    DateTime? birthDate,
    AuthGender? gender,
    bool clearName = false,
    bool clearNickname = false,
    bool clearBirthDate = false,
    bool clearGender = false,
  }) {
    return AuthUser(
      kakaoId: kakaoId ?? this.kakaoId,
      nickname: clearNickname ? null : (nickname ?? this.nickname),
      name: clearName ? null : (name ?? this.name),
      birthDate: clearBirthDate ? null : (birthDate ?? this.birthDate),
      gender: clearGender ? null : (gender ?? this.gender),
    );
  }
}