import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

class IeoBottomNavBar extends StatelessWidget {
  const IeoBottomNavBar({super.key});

  int _locationToIndex(String location) {
    if (location.startsWith('/match')) return 0;
    if (location.startsWith('/chat')) return 1;
    if (location.startsWith('/verification')) return 2;
    if (location.startsWith('/mypage')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _locationToIndex(location);

    return NavigationBar(
      height: 72,
      selectedIndex: currentIndex,
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFFF8F1DE),
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.go('/match');
            break;
          case 1:
            context.go('/chat');
            break;
          case 2:
            context.go('/verification');
            break;
          case 3:
            context.go('/mypage');
            break;
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.favorite_border, color: AppColors.textSecondary),
          selectedIcon: Icon(Icons.favorite, color: AppColors.primary),
          label: '매칭',
        ),
        NavigationDestination(
          icon: Icon(Icons.chat_bubble_outline, color: AppColors.textSecondary),
          selectedIcon: Icon(Icons.chat_bubble, color: AppColors.primary),
          label: '채팅',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.verified_user_outlined,
            color: AppColors.textSecondary,
          ),
          selectedIcon: Icon(Icons.verified_user, color: AppColors.primary),
          label: '인증',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline, color: AppColors.textSecondary),
          selectedIcon: Icon(Icons.person, color: AppColors.primary),
          label: '마이',
        ),
      ],
    );
  }
}
