import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// 약관·개인정보 처리방침은 gowoobro.com 에서 통합 관리한다(앱 프로젝트 id 5).
const String kTermsUrl = 'https://gowoobro.com/ko/app/5/terms';
const String kPrivacyUrl = 'https://gowoobro.com/ko/app/5/privacy';

Future<void> openLegalUrl(BuildContext context, String url) async {
  var opened = false;
  try {
    opened = await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView);
  } catch (_) {
    opened = false;
  }
  if (!opened && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('페이지를 열 수 없습니다. $url')),
    );
  }
}
