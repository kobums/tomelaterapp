import 'package:app/core/theme/app_theme.dart';
import 'package:app/features/auth/presentation/find_account_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FindAccountScreen extends ConsumerStatefulWidget {
  const FindAccountScreen({super.key});

  @override
  ConsumerState<FindAccountScreen> createState() => _FindAccountScreenState();
}

class _FindAccountScreenState extends ConsumerState<FindAccountScreen> {
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nicknameController.dispose();
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(findAccountViewModelProvider);
    final notifier = ref.read(findAccountViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('계정 찾기')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Tabs
            Row(
              children: [
                Expanded(
                  child: _TabButton(
                    text: '이메일 찾기',
                    isSelected: state.currentTab == FindAccountTab.email,
                    onTap: () => notifier.setTab(FindAccountTab.email),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _TabButton(
                    text: '비밀번호 찾기',
                    isSelected: state.currentTab == FindAccountTab.password,
                    onTap: () => notifier.setTab(FindAccountTab.password),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Content
            if (state.currentTab == FindAccountTab.email)
              _buildFindEmailSection(state, notifier)
            else
              _buildFindPasswordSection(state, notifier),
          ],
        ),
      ),
    );
  }

  Widget _buildFindEmailSection(FindAccountState state, FindAccountViewModel notifier) {
    if (state.foundEmail != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.check_circle_outline, size: 64, color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            '회원님의 이메일',
            textAlign: TextAlign.center,
            style: AppTextStyles.h4,
          ),
          const SizedBox(height: 8),
          Text(
            state.foundEmail!,
            textAlign: TextAlign.center,
            style: AppTextStyles.h3.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => context.go('/login'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
            ),
            child: const Text('로그인하러 가기'),
          ),
          TextButton(
            onPressed: notifier.resetFindEmail,
            child: const Text('다시 찾기'),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('가입 시 사용한 닉네임을 입력해 주세요.', textAlign: TextAlign.center),
        const SizedBox(height: 16),
        TextField(
          controller: _nicknameController,
          decoration: const InputDecoration(
            labelText: '닉네임',
            border: OutlineInputBorder(),
          ),
        ),
        if (state.findEmailError != null) ...[
          const SizedBox(height: 8),
          Text(state.findEmailError!, style: AppTextStyles.error),
        ],
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: state.isFindingEmail
              ? null
              : () => notifier.findEmail(_nicknameController.text),
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
          child: state.isFindingEmail
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('이메일 찾기'),
        ),
      ],
    );
  }


  Widget _buildFindPasswordSection(FindAccountState state, FindAccountViewModel notifier) {
    if (state.passwordSuccessMessage != null && state.passwordSuccessMessage!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.check_circle_outline, size: 64, color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            state.passwordSuccessMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/login'),
             style: ElevatedButton.styleFrom(
               padding: const EdgeInsets.symmetric(vertical: 16),
               backgroundColor: Colors.white,
               foregroundColor: AppColors.primary,
               side: const BorderSide(color: AppColors.primary),
             ),
            child: const Text('로그인하러 가기'),
          ),
        ],
      );
    }

    if (state.passwordStep == FindPasswordStep.request) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('가입 시 사용한 이메일을 입력해 주세요.\n비밀번호 재설정 코드를 발송해 드립니다.', textAlign: TextAlign.center),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: '이메일 주소',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          if (state.findPasswordError != null) ...[
            const SizedBox(height: 8),
            Text(state.findPasswordError!, style: AppTextStyles.error),
          ],
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: state.isSendingCode
                ? null
                : () => notifier.sendResetCode(_emailController.text),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
            ),
            child: state.isSendingCode
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('인증 코드 받기'),
          ),
        ],
      );
    }

    // Verify Step
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(state.email, style: const TextStyle(fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: notifier.resetPasswordStep,
              child: const Text('변경'),
            ),
          ],
        ),
        TextField(
          controller: _codeController,
          decoration: const InputDecoration(
            labelText: '인증 코드',
            border: OutlineInputBorder(),
          ),
          maxLength: 6,
          keyboardType: TextInputType.number,
        ),
        if (state.timeLeft > 0)
          Text(
            '남은 시간: ${notifier.formatTime(state.timeLeft)}',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
        const SizedBox(height: 16),
        TextField(
          controller: _newPasswordController,
          decoration: const InputDecoration(
            labelText: '새 비밀번호',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _confirmPasswordController,
          decoration: const InputDecoration(
            labelText: '새 비밀번호 확인',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        if (state.findPasswordError != null) ...[
          const SizedBox(height: 8),
          Text(state.findPasswordError!, style: const TextStyle(color: Colors.red)),
        ],
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: state.isResettingPassword
              ? null
              : () => notifier.resetPassword(
                    _codeController.text,
                    _newPasswordController.text,
                    _confirmPasswordController.text,
                  ),
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
          child: state.isResettingPassword
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('비밀번호 변경하기'),
        ),
      ],
    );
  }

}

class _TabButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : AppColors.grey100,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: AppSpacing.elevationLow,
                    offset: const Offset(0, 1),
                  )
                ]
              : null,
          border: isSelected ? null : Border.all(color: Colors.transparent),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppColors.primary : AppColors.grey600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
