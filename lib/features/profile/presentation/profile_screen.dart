import 'package:app/core/storage/storage_service.dart';
import 'package:app/features/auth/presentation/auth_view_model.dart';
import 'package:app/util/legal_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _confirmWithdraw(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('회원 탈퇴'),
        content: const Text(
          '탈퇴하면 계정과 작성한 모든 답변이 영구적으로 삭제되며 복구할 수 없습니다. 정말 탈퇴하시겠습니까?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('탈퇴하기'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(authViewModelProvider.notifier).withdraw();
      if (context.mounted) {
        context.go('/login');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storageService = ref.watch(storageServiceProvider);
    final nickname = storageService.getUserNickname() ?? 'Guest';
    final email = storageService.getUserEmail() ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Pretendard', 
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        scrolledUnderElevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          primary: false, // Fix for iOS tap-to-scroll conflict
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.indigo.shade100,
                      Colors.indigo.shade50.withOpacity(0.5),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    nickname.isNotEmpty ? nickname[0].toUpperCase() : 'U',
                    style: TextStyle(
                      fontFamily: 'Pretendard', // Assuming custom font
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                      color: Colors.indigo.shade400,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Name
              Text(
                nickname,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),

              // Email
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  email,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // Divider design element
              SizedBox(
                width: 40,
                child: Divider(
                  color: Colors.grey.shade200,
                  thickness: 2,
                ),
              ),

              const SizedBox(height: 40),

              // Terms of Service
              ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: () => openLegalUrl(context, kTermsUrl),
                title: const Text(
                  'Terms of Service',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ),

              // Privacy Policy
              ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: () => openLegalUrl(context, kPrivacyUrl),
                title: const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ),

              const SizedBox(height: 20),

              // Logout Button (Minimalist Red Outline)
              OutlinedButton(
                onPressed: () async {
                  await ref.read(authViewModelProvider.notifier).logout();
                  if (context.mounted) {
                    context.go('/login');
                  }
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade400,
                  side: BorderSide(color: Colors.red.shade100, width: 1.5),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.white,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Log out',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade400,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.logout_rounded,
                      size: 20,
                      color: Colors.red.shade400,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Delete Account (회원 탈퇴)
              TextButton(
                onPressed: () => _confirmWithdraw(context, ref),
                child: Text(
                  'Delete Account',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Version
              Text(
                'v1.0.0',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12,
                  color: Colors.grey.shade300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
