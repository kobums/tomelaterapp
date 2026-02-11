import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '개인정보 처리방침',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              '1. 개인정보의 처리 목적',
              '회사는 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며 이용 목적이 변경되는 경우에는 「개인정보 보호법」 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.\n\n- 서비스 제공 및 관리: 계정 생성 및 관리, 서비스 이용 기록 확인\n- 고객 지원: 문의 사항 처리 및 공지사항 전달',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '2. 개인정보의 처리 및 보유 기간',
              '회사는 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.\n\n- 회원 가입 정보: 회원 탈퇴 시까지\n- 관련 법령에 의한 보존 정보: 해당 법령에서 정한 기간까지',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '3. 정보주체와 법정대리인의 권리·의무 및 그 행사방법',
              '정보주체는 회사에 대해 언제든지 개인정보 열람·정정·삭제·처리정지 요구 등의 권리를 행사할 수 있습니다.',
            ),
             const SizedBox(height: 24),
            _buildSection(
              '4. 처리하는 개인정보의 항목',
              '회사는 다음의 개인정보 항목을 처리하고 있습니다.\n\n- 필수항목: 이메일, 비밀번호, 닉네임\n- 수집방법: 회원가입 시 수집',
            ),
            const SizedBox(height: 40),
            Text(
              '본 방침은 2026년 2월 11일부터 시행됩니다.',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 14,
            height: 1.6,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
