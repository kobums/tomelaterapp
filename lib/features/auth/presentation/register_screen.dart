import 'package:app/features/auth/presentation/register_view_model.dart';
import 'package:app/util/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nicknameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final success = await ref.read(registerViewModelProvider.notifier).register(
            nickname: _nicknameController.text,
            email: _emailController.text,
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
          );
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입 성공! 로그인해주세요.')),
        );
        context.pop(); // Go back to login
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerViewModelProvider);
    final notifier = ref.read(registerViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  labelText: '닉네임',
                  errorText: state.fieldErrors['nickname'],
                  helperText: '2~10자의 영문, 숫자, 한글',
                ),
                validator: (value) => ValidationUtils.validateNickname(value ?? ''),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: '이메일 주소',
                        errorText: state.fieldErrors['email'],
                      ),
                      enabled: !state.isEmailVerified,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => ValidationUtils.validateEmail(value ?? ''),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (!state.isEmailVerified)
                    ElevatedButton(
                      onPressed: state.isSendingCode || state.isEmailSent
                          ? null
                          : () {
                              notifier.sendVerificationCode(_emailController.text);
                            },
                      child: state.isSendingCode
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('인증코드'),
                    ),
                ],
              ),
              if (state.isEmailSent && !state.isEmailVerified) ...[
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _codeController,
                        decoration: InputDecoration(
                          labelText: '인증 코드',
                          errorText: state.fieldErrors['code'],
                          suffix: Text(
                            notifier.formatTime(state.timeLeft),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: state.isVerifyingCode
                          ? null
                          : () {
                              notifier.verifyCode(
                                  _emailController.text, _codeController.text);
                            },
                      child: state.isVerifyingCode
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('확인'),
                    ),
                  ],
                ),
              ],
              if (state.isEmailVerified) ...[
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 16),
                    SizedBox(width: 4),
                    Text('이메일 인증 완료', style: TextStyle(color: Colors.green)),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                  helperText: '영문, 숫자 포함 8자 이상',
                ),
                obscureText: true,
                validator: (value) => ValidationUtils.validatePassword(value ?? ''),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: '비밀번호 확인',
                  errorText: state.fieldErrors['confirmPassword'],
                ),
                obscureText: true,
                validator: (value) => ValidationUtils.validatePasswordMatch(
                  _passwordController.text,
                  value ?? '',
                ),
              ),
              const SizedBox(height: 24),
              if (state.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    state.error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              ElevatedButton(
                onPressed: state.isLoading || !state.isEmailVerified ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: state.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('회원가입'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
