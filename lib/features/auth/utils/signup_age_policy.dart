import '../models/auth_user.dart';

/// 한국 나이 계산
int getSignupPolicyAge(DateTime birthDate, DateTime now) {
  return now.year - birthDate.year + 1;
}

bool isEligibleForSignup({
  required AuthGender gender,
  required DateTime birthDate,
  DateTime? now,
}) {
  final current = now ?? DateTime.now();
  final age = getSignupPolicyAge(birthDate, current);

  switch (gender) {
    case AuthGender.female:
      return age >= 24;
    case AuthGender.male:
      return age >= 28;
  }
}

String getSignupIneligibleMessage(AuthGender gender) {
  switch (gender) {
    case AuthGender.female:
      return '이어는 서비스 가입 기준상 여성 24세 이상만 가입할 수 있어요.';
    case AuthGender.male:
      return '이어는 서비스 가입 기준상 남성 28세 이상만 가입할 수 있어요.';
  }
}
