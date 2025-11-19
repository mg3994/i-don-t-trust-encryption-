import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/feed/presentation/pages/feed_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinkWithMentor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Default to dark theme
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = signal(0);

    final pages = [
      const FeedPage(),
      const SearchPage(),
      const CreatePostPage(),
      const NotificationsPage(),
      const ProfilePage(),
    ];

    return Watch((context) {
      return Scaffold(
        body: pages[currentIndex.value],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex.value,
            onTap: (index) => currentIndex.value = index,
            type: BottomNavigationBarType.fixed,
            items: [
              _buildNavItem(
                PhosphorIcons.house(),
                PhosphorIcons.house(PhosphorIconsStyle.fill),
                'Home',
                0,
                currentIndex.value,
              ),
              _buildNavItem(
                PhosphorIcons.magnifyingGlass(),
                PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.fill),
                'Search',
                1,
                currentIndex.value,
              ),
              _buildNavItem(
                PhosphorIcons.plusCircle(),
                PhosphorIcons.plusCircle(PhosphorIconsStyle.fill),
                'Create',
                2,
                currentIndex.value,
              ),
              _buildNavItem(
                PhosphorIcons.bell(),
                PhosphorIcons.bell(PhosphorIconsStyle.fill),
                'Notifications',
                3,
                currentIndex.value,
              ),
              _buildNavItem(
                PhosphorIcons.user(),
                PhosphorIcons.user(PhosphorIconsStyle.fill),
                'Profile',
                4,
                currentIndex.value,
              ),
            ],
          ),
        ),
      );
    });
  }

  BottomNavigationBarItem _buildNavItem(
    PhosphorIconData icon,
    PhosphorIconData activeIcon,
    String label,
    int index,
    int currentIndex,
  ) {
    return BottomNavigationBarItem(
      icon: PhosphorIcon(icon)
          .animate(target: currentIndex == index ? 1 : 0)
          .scale(end: const Offset(1.2, 1.2)),
      activeIcon: PhosphorIcon(activeIcon),
      label: label,
    );
  }
}

// Placeholder pages
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PhosphorIcon(
                  PhosphorIcons.magnifyingGlass(),
                  size: 64,
                  color: AppTheme.primaryColor.withValues(alpha: 0.5),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(duration: 2000.ms),
            const SizedBox(height: 24),
            Text('Search', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('Coming Soon', style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.primaryGradient,
                  ),
                  padding: const EdgeInsets.all(24),
                  child: PhosphorIcon(
                    PhosphorIcons.plusCircle(PhosphorIconsStyle.fill),
                    size: 64,
                    color: Colors.white,
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .scale(
                  duration: 2000.ms,
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                ),
            const SizedBox(height: 24),
            Text('Create Post', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('Coming Soon', style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PhosphorIcon(
                  PhosphorIcons.bell(PhosphorIconsStyle.fill),
                  size: 64,
                  color: AppTheme.secondaryColor.withValues(alpha: 0.5),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .shake(duration: 2000.ms),
            const SizedBox(height: 24),
            Text('Notifications', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('Coming Soon', style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
