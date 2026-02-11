import 'package:app/core/storage/storage_service.dart';
import 'package:app/features/auth/presentation/find_account_screen.dart';
import 'package:app/features/auth/presentation/login_screen.dart';
import 'package:app/features/auth/presentation/register_screen.dart';
import 'package:app/features/history/presentation/history_detail_screen.dart';
import 'package:app/features/history/presentation/history_screen.dart';
import 'package:app/features/profile/presentation/profile_screen.dart';
import 'package:app/features/profile/presentation/privacy_policy_screen.dart';
import 'package:app/features/question/presentation/question_screen.dart';
import 'package:app/shared/models/answer.dart';
import 'package:app/shared/scaffold_with_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final storageService = ref.watch(storageServiceProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/login',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final token = storageService.getToken();
      final isLoggingIn = state.uri.path == '/login' || 
                          state.uri.path == '/register' || 
                          state.uri.path == '/find-account';

      if (token == null && !isLoggingIn) {
        return '/login';
      }

      if (token != null && isLoggingIn) {
        return '/question';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/find-account',
        builder: (context, state) => const FindAccountScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/question',
                builder: (context, state) => const QuestionScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/history',
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                routes: [
                  GoRoute(
                    path: 'privacy-policy',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const PrivacyPolicyScreen(),
                  ),
                ],
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/history/detail',
        parentNavigatorKey: rootNavigatorKey, // Ensure it sits above the shell
        pageBuilder: (context, state) {
          final answer = state.extra as Answer;
          return CustomTransitionPage(
            key: state.pageKey,
            child: HistoryDetailScreen(answer: answer),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            opaque: false,
          );
        },
      ),
    ],
  );
});

