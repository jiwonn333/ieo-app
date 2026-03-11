import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/ieo_filled_button.dart';
import '../models/auth_user.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_header.dart';

class IdentityConfirmScreen extends ConsumerStatefulWidget {
  final AuthUser user;

  const IdentityConfirmScreen({super.key, required this.user});

  @override
  ConsumerState<IdentityConfirmScreen> createState() =>
      _IdentityConfirmScreenState();
}

class _IdentityConfirmScreenState extends ConsumerState<IdentityConfirmScreen> {
  late final TextEditingController _appNicknameController;
  late final TextEditingController _kakaoNicknameController;
  late final TextEditingController _nameController;
  late final TextEditingController _birthDateController;
  bool _isSaving = false;

  bool get _canProceed =>
      _appNicknameController.text.trim().isNotEmpty && !_isSaving;

  @override
  void initState() {
    super.initState();

    _appNicknameController = TextEditingController(
      text: widget.user.nickname ?? '',
    )..addListener(_refresh);

    _kakaoNicknameController = TextEditingController(
      text: widget.user.nickname ?? '',
    );

    _nameController = TextEditingController(text: widget.user.name ?? '');

    _birthDateController = TextEditingController(
      text: widget.user.birthDateText ?? '',
    );
  }

  @override
  void dispose() {
    _appNicknameController.removeListener(_refresh);
    _appNicknameController.dispose();
    _kakaoNicknameController.dispose();
    _nameController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  void _refresh() {
    setState(() {});
  }

  Future<void> _handleNext() async {
    if (!_canProceed) return;

    try {
      setState(() => _isSaving = true);

      final repo = ref.read(userRepositoryProvider);

      await repo.createUser(
        authUser: widget.user,
        appNickname: _appNicknameController.text.trim(),
      );

      await ref.read(signupFlowRepositoryProvider).clear();

      if (!mounted) return;
      context.go('/match');
    } catch (e) {
      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('회원가입 실패'),
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasName = (widget.user.name ?? '').trim().isNotEmpty;
    final hasBirthDate = widget.user.birthDate != null;
    final hasGender = widget.user.gender != null;

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
              const AuthHeader(progress: 0.66, showBackButton: true),
              const SizedBox(height: 44),
              Text(
                '본인 정보가 맞는지\n정확히 확인해주세요',
                style: AppTextStyles.headlineLarge.copyWith(height: 1.3),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                '카카오 계정에서 불러온 정보입니다.\n정확한 매칭을 위해 신중히 확인해 주세요.',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 36),

              _IdentityField(
                label: '카카오 닉네임',
                controller: _kakaoNicknameController,
                hintText: '카카오 닉네임',
                readOnly: true,
              ),
              const SizedBox(height: AppSpacing.lg),

              _IdentityField(
                label: '앱에서 사용할 닉네임',
                controller: _appNicknameController,
                hintText: '앱에서 사용할 닉네임을 입력해주세요',
                readOnly: false,
              ),
              const SizedBox(height: AppSpacing.lg),

              _IdentityField(
                label: '이름',
                controller: _nameController,
                hintText: '이름 정보가 아직 연동되지 않았어요',
                readOnly: true,
              ),
              const SizedBox(height: AppSpacing.lg),

              _IdentityField(
                label: '생년월일',
                controller: _birthDateController,
                hintText: '생년월일 정보가 아직 연동되지 않았어요',
                readOnly: true,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.lg),

              Text(
                '성별',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                width: double.infinity,
                height: 62,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.border),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.user.genderKo ?? '성별 정보가 아직 연동되지 않았어요',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: widget.user.genderKo != null
                        ? AppColors.textPrimary
                        : AppColors.textHint,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBF1),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: const Color(0xFFF1E3B9)),
                ),
                child: Text(
                  [
                    '안내',
                    hasName && hasBirthDate && hasGender
                        ? '이름, 생년월일, 성별 정보가 정상적으로 확인되었어요.'
                        : '현재 일부 카카오 동의항목은 아직 연동 전입니다.',
                    '회원 저장 시 카카오 식별값(kakaoId) 기준으로 가입 상태를 관리하게 됩니다.',
                  ].join('\n'),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryDark,
                    height: 1.7,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xxxl),

              IeoFilledButton(
                label: _isSaving ? '저장 중...' : '다음',
                onPressed: _canProceed ? _handleNext : null,
              ),

              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _IdentityField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final bool readOnly;
  final TextInputType? keyboardType;

  const _IdentityField({
    required this.label,
    required this.controller,
    required this.hintText,
    required this.readOnly,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textHint,
              fontWeight: FontWeight.w500,
            ),
            suffixIcon: readOnly
                ? const Padding(
                    padding: EdgeInsets.only(right: 14),
                    child: Icon(
                      Icons.lock_outline_rounded,
                      color: AppColors.textHint,
                      size: 20,
                    ),
                  )
                : null,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 44,
              minHeight: 44,
            ),
          ),
        ),
      ],
    );
  }
}
