import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/ieo_filled_button.dart';
import '../widgets/auth_header.dart';

class IdentityConfirmScreen extends StatefulWidget {
  const IdentityConfirmScreen({super.key});

  @override
  State<IdentityConfirmScreen> createState() => _IdentityConfirmScreenState();
}

class _IdentityConfirmScreenState extends State<IdentityConfirmScreen> {
  final String? fetchedName = '신지원';
  final String? fetchedBirthDate = '20000112';
  final String? fetchedGender = '여성';

  late final TextEditingController _nameController;
  late final TextEditingController _birthController;
  String? _selectedGender;

  bool get _isNameLocked => fetchedName != null && fetchedName!.trim().isNotEmpty;
  bool get _isBirthLocked =>
      fetchedBirthDate != null && fetchedBirthDate!.trim().isNotEmpty;
  bool get _isGenderLocked =>
      fetchedGender != null && fetchedGender!.trim().isNotEmpty;

  bool get _canProceed {
    final hasName = _nameController.text.trim().isNotEmpty;
    final hasBirth = _birthController.text.trim().isNotEmpty;
    final hasGender = (_selectedGender ?? '').isNotEmpty;
    return hasName && hasBirth && hasGender;
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: fetchedName ?? '');
    _birthController = TextEditingController(text: fetchedBirthDate ?? '');
    _selectedGender = fetchedGender;
    _nameController.addListener(_refresh);
    _birthController.addListener(_refresh);
  }

  @override
  void dispose() {
    _nameController.removeListener(_refresh);
    _birthController.removeListener(_refresh);
    _nameController.dispose();
    _birthController.dispose();
    super.dispose();
  }

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
              const AuthHeader(
                progress: 0.66,
                showBackButton: true,
              ),
              const SizedBox(height: 44),
              Text(
                '본인 정보가 맞는지\n정확히 확인해주세요',
                style: AppTextStyles.headlineLarge.copyWith(
                  height: 1.3,
                ),
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
                label: '이름',
                controller: _nameController,
                hintText: '이름 정보가 없을 경우 입력해주세요',
                readOnly: _isNameLocked,
              ),
              const SizedBox(height: AppSpacing.lg),
              _IdentityField(
                label: '생년월일',
                controller: _birthController,
                hintText: 'YYYYMMDD',
                readOnly: _isBirthLocked,
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
              Row(
                children: [
                  Expanded(
                    child: _GenderButton(
                      label: '남성',
                      selected: _selectedGender == '남성',
                      enabled: !_isGenderLocked,
                      onTap: () {
                        if (_isGenderLocked) return;
                        setState(() => _selectedGender = '남성');
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: _GenderButton(
                      label: '여성',
                      selected: _selectedGender == '여성',
                      enabled: !_isGenderLocked,
                      onTap: () {
                        if (_isGenderLocked) return;
                        setState(() => _selectedGender = '여성');
                      },
                    ),
                  ),
                ],
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
                  '주의사항\n이름, 생년월일, 성별은 가입 후 프로필에서 수정할 수 있습니다.\n단, 수정 전 내용은 기록으로 함께 보관됩니다.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryDark,
                    height: 1.7,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              IeoFilledButton(
                label: '다음',
                onPressed: _canProceed ? () => context.go('/match') : null,
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

class _GenderButton extends StatelessWidget {
  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  const _GenderButton({
    required this.label,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = selected
        ? const Color(0xFFFFF6DE)
        : enabled
        ? AppColors.surface
        : AppColors.surfaceAlt;

    final borderColor = selected
        ? AppColors.primary
        : enabled
        ? AppColors.borderStrong
        : AppColors.border;

    final textColor = selected
        ? AppColors.primaryDark
        : enabled
        ? AppColors.textSecondary
        : AppColors.textHint;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        height: 62,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: borderColor, width: 1.4),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.titleMedium.copyWith(
            color: textColor,
          ),
        ),
      ),
    );
  }
}