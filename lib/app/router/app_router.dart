import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/views/identity_confirm_screen.dart';
import '../../features/auth/views/login_screen.dart';
import '../../features/chat/views/chat_list_screen.dart';
import '../../features/match/views/match_home_screen.dart';
import '../../features/mypage/views/mypage_screen.dart';
import '../../features/onboarding/views/onboarding_screen.dart';
import '../../features/verification/views/verification_screen.dart';
import '../../shared/widgets/ieo_bottom_nav_bar.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/identity-confirm',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: IdentityConfirmScreen(),
        ),
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