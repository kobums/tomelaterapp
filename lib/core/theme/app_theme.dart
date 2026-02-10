import 'package:flutter/material.dart';

/// Toss Design System Colors
/// Based on Gym's clean and modern design language
class AppColors {
  // Primary Colors - Gym Blue
  static const primary = Color(0xFF3182F6);  // Gym Blue
  static const primaryPressed = Color(0xFF1B64DA);  // Darker blue for pressed state
  static const primaryLight = Color(0xFFEBF4FF);  // Light blue background
  static const onPrimary = Color(0xFFFFFFFF);

  // Grayscale - Gym Grayscale System
  static const grey50 = Color(0xFFF9FAFB);
  static const grey100 = Color(0xFFF2F4F6);
  static const grey200 = Color(0xFFE5E8EB);
  static const grey300 = Color(0xFFD1D6DB);
  static const grey400 = Color(0xFFB0B8C1);
  static const grey500 = Color(0xFF8B95A1);
  static const grey600 = Color(0xFF6B7684);
  static const grey700 = Color(0xFF4E5968);
  static const grey800 = Color(0xFF333D4B);
  static const grey900 = Color(0xFF191F28);

  // Text Colors
  static const textPrimary = grey900;
  static const textSecondary = grey700;
  static const textTertiary = grey500;
  static const textDisabled = grey400;
  static const textInverse = Color(0xFFFFFFFF);

  // Background Colors
  static const background = Color(0xFFFFFFFF);
  static const backgroundElevated = Color(0xFFFFFFFF);
  static const backgroundDimmed = grey50;
  static const surface = grey100;
  static const onBackground = grey900;
  static const onSurface = grey900;

  // Status Colors
  static const success = Color(0xFF0BC27C);  // Toss green
  static const successLight = Color(0xFFE8FAF4);
  static const onSuccess = Color(0xFFFFFFFF);

  static const error = Color(0xFFF04452);  // Toss red
  static const errorLight = Color(0xFFFFF0F1);
  static const onError = Color(0xFFFFFFFF);

  static const warning = Color(0xFFF89A24);  // Toss orange
  static const warningLight = Color(0xFFFFF5E6);
  static const onWarning = Color(0xFF000000);

  static const info = Color(0xFF3182F6);  // Same as primary
  static const infoLight = Color(0xFFEBF4FF);
  static const onInfo = Color(0xFFFFFFFF);

  // Social Login Colors
  static const kakao = Color(0xFFFEE500);
  static const kakaoLabel = Color(0xFF000000);
  static const naver = Color(0xFF03C75A);
  static const naverLabel = Color(0xFFFFFFFF);
  static const google = Color(0xFFFFFFFF);
  static const googleLabel = Color(0xFF000000);
  static const apple = Color(0xFF000000);
  static const appleLabel = Color(0xFFFFFFFF);

  // Border Colors
  static const border = grey300;
  static const borderLight = grey200;
  static const borderStrong = grey500;

  // Overlay Colors
  static const overlay = Color(0x80000000);  // 50% black
  static const overlayLight = Color(0x1A000000);  // 10% black

  // Membership Status Colors
  static const membershipActive = success;
  static const membershipExpiringSoon = warning;
  static const membershipExpired = grey500;
  static const membershipPaused = info;

  // Divider
  static const divider = grey200;
}

/// Toss Design System Spacing
/// Consistent spacing and sizing system based on 4px grid
class AppSpacing {
  // Base spacing units (4px grid system)
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double huge = 40.0;
  static const double massive = 48.0;

  // Semantic spacing
  static const double elementGap = sm;
  static const double sectionGap = xxl;
  static const double screenPadding = lg;
  static const double screenPaddingHorizontal = lg;
  static const double screenPaddingVertical = xxl;
  static const double cardPadding = lg;
  static const double listItemPadding = lg;

  // Component heights
  static const double buttonHeightSmall = 40.0;
  static const double buttonHeightMedium = 52.0;
  static const double buttonHeightLarge = 60.0;
  static const double textFieldHeight = 52.0;
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 64.0;

  // Border radius (Gym uses larger radius for modern look)
  static const double radiusXSmall = 4.0;
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;
  static const double radiusXXLarge = 24.0;
  static const double radiusCircle = 9999.0;

  // Icon sizes
  static const double iconXSmall = 12.0;
  static const double iconSmall = 16.0;
  static const double iconMedium = 20.0;
  static const double iconLarge = 24.0;
  static const double iconXLarge = 32.0;
  static const double iconXXLarge = 48.0;

  // Avatar sizes
  static const double avatarSmall = 32.0;
  static const double avatarMedium = 40.0;
  static const double avatarLarge = 56.0;
  static const double avatarXLarge = 80.0;

  // Elevation (for shadows)
  static const double elevationNone = 0.0;
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
  static const double elevationHighest = 16.0;

  // Border width
  static const double borderThin = 1.0;
  static const double borderMedium = 1.5;
  static const double borderThick = 2.0;

  // Divider
  static const double dividerThickness = 1.0;
}

/// Toss Design System Typography
/// Clean, readable typography inspired by Gym's design language
class AppTextStyles {
  // Display - For hero sections and large headings
  static const displayLarge = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  static const displayMedium = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  static const displaySmall = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  // Headings - For section titles
  static const h1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.35,
    letterSpacing: -0.3,
    color: AppColors.textPrimary,
  );

  static const h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: -0.3,
    color: AppColors.textPrimary,
  );

  static const h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );

  static const h4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.45,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );

  // Title - For card titles and labels
  static const titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.45,
    color: AppColors.textPrimary,
  );

  static const titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  // Body - For main content
  static const bodyLarge = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.textPrimary,
  );

  static const bodyMedium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.textPrimary,
  );

  static const bodySmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.textSecondary,
  );

  // Labels - For input labels and small text
  static const labelLarge = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  static const labelMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  static const labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.textTertiary,
  );

  // Button - For buttons
  static const buttonLarge = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: -0.2,
  );

  static const buttonMedium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: -0.2,
  );

  static const buttonSmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: -0.1,
  );

  // Legacy button style for backward compatibility
  static const button = buttonMedium;

  // Caption - For hints and helper text
  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textTertiary,
  );

  // Link
  static const link = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );

  // Status messages
  static const error = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.error,
  );

  static const success = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.success,
  );

  static const warning = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.warning,
  );
}

/// App Theme Configuration
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: Colors.pinkAccent,
        surface: AppColors.surface,
      ),
      useMaterial3: true,
      fontFamily: 'Pretendard',
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: AppTextStyles.buttonMedium,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: AppColors.grey200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: const TextStyle(color: AppColors.grey600),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: AppSpacing.dividerThickness,
        space: 0,
      ),
    );
  }
}
