///onboarding : 아직 온보딩 중이거나 온보딩으로 가야 함
/// login : 온보딩 끝났고 로그인 화면으로 가야 함
/// identityConfirm : 카카오 로그인 성공했고 회원정보확인으로 가야 함
/// 가입 완료되면 바로 clear()
enum SignupStep {
  onboarding,
  login,
  identityConfirm,
}