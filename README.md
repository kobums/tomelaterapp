# Mobile App (To Me, Later)

`To Me, Later`의 모바일 애플리케이션입니다. Flutter로 구축되었습니다.

## 🛠 설치 및 실행 (Setup & Run)

### 사전 요구사항
- Flutter SDK 3.10 이상
- Xcode (iOS 개발 시)
- Android Studio (Android 개발 시)

### 1. 패키지 설치
`app` 디렉토리로 이동하여 의존성 패키지를 설치합니다.

```bash
cd app
flutter pub get
```

### 2. 코드 생성 (Build Runner)
Riverpod Generator 등을 사용하므로 코드 생성이 필요합니다.
파일 변경 시 자동으로 코드를 생성하려면 `watch` 옵션을 사용하세요.

```bash
dart run build_runner build -d
# 또는 개발 중 실시간 반영
dart run build_runner watch -d
```

### 3. 앱 실행
```bash
flutter run
```

## 📁 디렉토리 구조
```
app/
├── assets/          # 이미지, 폰트 등 정적 리소스
├── lib/
│   ├── main.dart    # 앱 진입점
│   ├── models/      # 데이터 모델 (JSON Serialization)
│   ├── providers/   # 상태 관리 (Riverpod)
│   ├── screens/     # 화면 UI (GoRouter 연동)
│   ├── services/    # 외부 서비스 연동 (API, Storage 등)
│   └── widgets/     # 공통 위젯
└── pubspec.yaml     # 패키지 및 설정
```

## 🚀 주요 라이브러리
- **Flutter Riverpod**: 상태 관리
- **Go Router**: 라우팅
- **Dio**: HTTP 통신
- **Shared Preferences**: 로컬 저장소
- **Intl**: 다국어 지원
