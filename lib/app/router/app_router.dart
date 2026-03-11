import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/models/auth_user.dart';
import '../../features/auth/views/identity_confirm_screen.dart';
import '../../features/auth/views/login_screen.dart';
import '../../features/chat/views/chat_list_screen.dart';
import '../../features/match/views/match_home_screen.dart';
import '../../features/mypage/views/mypage_screen.dart';
import '../../features/onboarding/views/onboarding_screen.dart';
import '../../features/verification/views/verification_screen.dart';
import '../../shared/widgets/ieo_bottom_nav_bar.dart';
import '../launch/launch_gate_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    errorBuilder: (context, state) {
      return Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'location: ${state.uri}\nerror: ${state.error}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LaunchGateScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/identity-confirm',
        pageBuilder: (context, state) {
          final extra = state.extra;

          if (extra is! AuthUser) {
            return const NoTransitionPage(child: LoginScreen());
          }

          return NoTransitionPage(child: IdentityConfirmScreen(user: extra));
        },
      ),
      ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            body: child,
            bottomNavigationBar: const IeoBottomNavBar(),
          );
        },
        routes: [
          GoRoute(
            path: '/match',
            builder: (context, state) => const MatchHomeScreen(),
          ),
          GoRoute(
            path: '/chat',
            builder: (context, state) => const ChatListScreen(),
          ),
          GoRoute(
            path: '/verification',
            builder: (context, state) => const VerificationScreen(),
          ),
          GoRoute(
            path: '/mypage',
            builder: (context, state) => const MyPageScreen(),
          ),
        ],
      ),
    ],
  );
});
