import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../../../core/theme/app_theme.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchQuery = signal('');
    final selectedCategory = signal(0);

    final categories = ['All', 'People', 'Topics', 'Events', 'Communities'];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Search Header
          SliverAppBar(
            floating: true,
            snap: true,
            expandedHeight: 140,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                child: Column(
                  children: [
                    // Search Bar
                    Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(2),
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: TextField(
                              onChanged: (value) => searchQuery.value = value,
                              style: theme.textTheme.bodyLarge,
                              decoration: InputDecoration(
                                hintText: 'Discover amazing content...',
                                hintStyle: theme.textTheme.bodyMedium,
                                prefixIcon: PhosphorIcon(
                                  PhosphorIcons.magnifyingGlass(),
                                  color: AppTheme.primaryColor,
                                ),
                                suffixIcon: PhosphorIcon(
                                  PhosphorIcons.faders(),
                                  color: theme.iconTheme.color,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: -0.2, end: 0),
                  ],
                ),
              ),
            ),
          ),

          // Category Pills
          SliverToBoxAdapter(
            child: SizedBox(
              height: 44,
              child: Watch((context) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedCategory.value == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildCategoryPill(
                        context,
                        categories[index],
                        isSelected,
                        () => selectedCategory.value = index,
                      ),
                    ).animate().fadeIn(delay: (index * 50).ms);
                  },
                );
              }),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Trending Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: PhosphorIcon(
                      PhosphorIcons.trendUp(PhosphorIconsStyle.fill),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('Trending Now', style: theme.textTheme.titleLarge),
                ],
              ).animate().fadeIn(delay: 200.ms),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Trending Cards - Horizontal Scroll
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _buildTrendingCard(context, index);
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Discover Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: AppTheme.accentGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: PhosphorIcon(
                      PhosphorIcons.compass(PhosphorIconsStyle.fill),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('Discover', style: theme.textTheme.titleLarge),
                ],
              ).animate().fadeIn(delay: 400.ms),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Discovery Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return _buildDiscoveryCard(context, index);
              }, childCount: 10),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  Widget _buildCategoryPill(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: 200.ms,
        curve: Curves.easeOut,
        padding: EdgeInsets.all(isSelected ? 2 : 1),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                )
              : null,
          borderRadius: BorderRadius.circular(22),
          border: isSelected
              ? null
              : Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? null : theme.cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Colors.white
                  : theme.textTheme.bodyMedium?.color ?? Colors.grey,
            ),
          ),
        ),
      ),
    ).animate(target: isSelected ? 1 : 0).scale(end: const Offset(1.03, 1.03));
  }

  Widget _buildTrendingCard(BuildContext context, int index) {
    final gradients = [
      [const Color(0xFF6C5CE7), const Color(0xFFA29BFE)],
      [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
      [const Color(0xFF00B894), const Color(0xFF55EFC4)],
      [const Color(0xFFFD79A8), const Color(0xFFFFBE76)],
      [const Color(0xFF6C5CE7), const Color(0xFFFD79A8)],
    ];

    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradients[index % gradients.length],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: CustomPaint(painter: _PatternPainter()),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '🔥 Trending',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Flutter Development Tips',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${1200 + index * 300}+ discussions',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.2, end: 0);
  }

  Widget _buildDiscoveryCard(BuildContext context, int index) {
    final theme = Theme.of(context);
    final icons = [
      PhosphorIcons.code(),
      PhosphorIcons.palette(),
      PhosphorIcons.lightbulb(),
      PhosphorIcons.rocket(),
      PhosphorIcons.brain(),
      PhosphorIcons.heart(),
      PhosphorIcons.star(),
      PhosphorIcons.trophy(),
      PhosphorIcons.fire(),
      PhosphorIcons.sparkle(),
    ];

    final titles = [
      'Coding',
      'Design',
      'Ideas',
      'Startups',
      'Learning',
      'Wellness',
      'Featured',
      'Achievements',
      'Hot Topics',
      'Inspiration',
    ];

    return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF6C5CE7).withValues(alpha: 0.2),
                            Color(0xFFFD79A8).withValues(alpha: 0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: PhosphorIcon(
                        icons[index % icons.length],
                        size: 32,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      titles[index % titles.length],
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(index + 1) * 234} posts',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: (index * 50).ms)
        .scale(begin: const Offset(0.8, 0.8));
  }
}

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (var i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.2 + i * 20),
        10 + i * 5,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
