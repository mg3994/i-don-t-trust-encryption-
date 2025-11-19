import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedTab = signal(0);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Profile Header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                children: [
                  const SizedBox(height: 32),
                  // Profile Picture with Gradient Border
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6C5CE7), Color(0xFFFD79A8)],
                      ),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.scaffoldBackgroundColor,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundColor: Color(0xFF6C5CE7),
                        child: Text(
                          'JD',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ).animate().scale(duration: 400.ms),
                  const SizedBox(height: 12),
                  Text(
                    'John Doe',
                    style: theme.textTheme.headlineMedium,
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 4),
                  Text(
                    '@johndoe',
                    style: theme.textTheme.bodyMedium,
                  ).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Flutter Developer 💙 | Tech Enthusiast | Coffee Lover ☕',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: PhosphorIcon(PhosphorIcons.gear()),
                onPressed: () {},
              ),
            ],
          ),

          // Stats
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('Posts', '234'),
                  _buildStat('Followers', '12.5K'),
                  _buildStat('Following', '892'),
                ],
              ).animate().fadeIn(delay: 500.ms),
            ),
          ),

          // Action Buttons
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      'Edit Profile',
                      PhosphorIcons.pencilSimple(),
                      isPrimary: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      'Share Profile',
                      PhosphorIcons.shareNetwork(),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 600.ms),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Tabs
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              child: Watch((context) {
                return Container(
                  color: theme.scaffoldBackgroundColor,
                  child: Row(
                    children: [
                      _buildTab(
                        context,
                        PhosphorIcons.gridFour(),
                        0,
                        selectedTab,
                      ),
                      _buildTab(
                        context,
                        PhosphorIcons.videoCamera(),
                        1,
                        selectedTab,
                      ),
                      _buildTab(context, PhosphorIcons.heart(), 2, selectedTab),
                    ],
                  ),
                );
              }),
            ),
          ),

          // Content Grid
          Watch((context) {
            return SliverPadding(
              padding: const EdgeInsets.all(2),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  return _buildGridItem(context, index);
                }, childCount: 24),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    PhosphorIconData icon, {
    bool isPrimary = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: isPrimary
            ? const LinearGradient(
                colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
              )
            : null,
        color: isPrimary ? null : Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PhosphorIcon(icon, size: 18, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(
    BuildContext context,
    PhosphorIconData icon,
    int index,
    Signal<int> selectedTab,
  ) {
    final isSelected = selectedTab.value == index;
    final theme = Theme.of(context);

    return Expanded(
      child: InkWell(
        onTap: () => selectedTab.value = index,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? const Color(0xFF6C5CE7)
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: PhosphorIcon(
            icon,
            color: isSelected
                ? const Color(0xFF6C5CE7)
                : theme.iconTheme.color?.withValues(alpha: 0.5),
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF6C5CE7).withValues(alpha: 0.3 + (index % 3) * 0.1),
            Color(0xFFFD79A8).withValues(alpha: 0.3 + (index % 3) * 0.1),
          ],
        ),
      ),
      child: Center(
        child: PhosphorIcon(
          PhosphorIcons.image(),
          size: 32,
          color: Colors.white.withValues(alpha: 0.5),
        ),
      ),
    ).animate().fadeIn(delay: (index * 30).ms);
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _TabBarDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
