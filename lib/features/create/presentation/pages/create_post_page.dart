import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../../../core/theme/app_theme.dart';

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final postContent = signal('');
    final selectedMood = signal(0);
    final selectedVisibility = signal(0);

    final moods = [
      '😊 Happy',
      '💡 Inspired',
      '🎯 Focused',
      '🎨 Creative',
      '🚀 Excited',
    ];
    final visibilities = ['Public', 'Friends', 'Private'];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            floating: true,
            snap: true,
            title: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF6C5CE7), Color(0xFFFD79A8)],
              ).createShader(bounds),
              child: const Text(
                'Create Magic ✨',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        'Post',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms),
            ],
          ),

          // Main Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Composition Card
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor.withValues(alpha: 0.1),
                        AppTheme.secondaryColor.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text Input
                      TextField(
                        onChanged: (value) => postContent.value = value,
                        maxLines: 8,
                        style: theme.textTheme.bodyLarge,
                        decoration: InputDecoration(
                          hintText:
                              'What\'s on your mind? Share your thoughts...',
                          hintStyle: theme.textTheme.bodyMedium,
                          border: InputBorder.none,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Character Count
                      Watch((context) {
                        return Text(
                          '${postContent.value.length} characters',
                          style: theme.textTheme.bodySmall,
                        );
                      }),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 20),

                // Mood Selector
                Text(
                  'How are you feeling?',
                  style: theme.textTheme.titleLarge,
                ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 12),

                Watch((context) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(moods.length, (index) {
                      final isSelected = selectedMood.value == index;
                      return _buildMoodChip(
                        moods[index],
                        isSelected,
                        () => selectedMood.value = index,
                        index,
                      );
                    }),
                  );
                }),

                const SizedBox(height: 24),

                // Media Options
                Text(
                  'Add to your post',
                  style: theme.textTheme.titleLarge,
                ).animate().fadeIn(delay: 400.ms),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _buildMediaOption(
                        PhosphorIcons.image(),
                        'Photo',
                        const Color(0xFF00B894),
                        0,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMediaOption(
                        PhosphorIcons.videoCamera(),
                        'Video',
                        const Color(0xFFFF6B6B),
                        1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _buildMediaOption(
                        PhosphorIcons.link(),
                        'Link',
                        const Color(0xFF6C5CE7),
                        2,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMediaOption(
                        PhosphorIcons.fileText(),
                        'Document',
                        const Color(0xFFFD79A8),
                        3,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Visibility Selector
                Text(
                  'Who can see this?',
                  style: theme.textTheme.titleLarge,
                ).animate().fadeIn(delay: 600.ms),

                const SizedBox(height: 12),

                Watch((context) {
                  return Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      children: List.generate(visibilities.length, (index) {
                        final isSelected = selectedVisibility.value == index;
                        final icons = [
                          PhosphorIcons.globe(),
                          PhosphorIcons.users(),
                          PhosphorIcons.lock(),
                        ];

                        return _buildVisibilityOption(
                          icons[index],
                          visibilities[index],
                          isSelected,
                          () => selectedVisibility.value = index,
                          index == visibilities.length - 1,
                        );
                      }),
                    ),
                  );
                }),

                const SizedBox(height: 24),

                // Advanced Options
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF6C5CE7).withValues(alpha: 0.1),
                        const Color(0xFF00B894).withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          PhosphorIcon(
                            PhosphorIcons.sparkle(PhosphorIconsStyle.fill),
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Advanced Options',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildToggleOption(
                        PhosphorIcons.chatCircle(),
                        'Allow comments',
                        true,
                      ),
                      const SizedBox(height: 12),
                      _buildToggleOption(
                        PhosphorIcons.shareNetwork(),
                        'Allow sharing',
                        true,
                      ),
                      const SizedBox(height: 12),
                      _buildToggleOption(
                        PhosphorIcons.bell(),
                        'Notify followers',
                        false,
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 800.ms),

                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodChip(
    String label,
    bool isSelected,
    VoidCallback onTap,
    int index,
  ) {
    return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                    )
                  : null,
              color: isSelected ? null : Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: isSelected
                  ? null
                  : Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: (index * 50).ms)
        .scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildMediaOption(
    PhosphorIconData icon,
    String label,
    Color color,
    int index,
  ) {
    return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.2),
                color.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    PhosphorIcon(icon, color: color, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: (400 + index * 50).ms)
        .scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildVisibilityOption(
    PhosphorIconData icon,
    String label,
    bool isSelected,
    VoidCallback onTap,
    bool isLast,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryColor
                    : Colors.grey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: PhosphorIcon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppTheme.primaryColor : Colors.grey,
                ),
              ),
            ),
            if (isSelected)
              PhosphorIcon(
                PhosphorIcons.check(PhosphorIconsStyle.fill),
                color: AppTheme.primaryColor,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleOption(PhosphorIconData icon, String label, bool value) {
    return Row(
      children: [
        PhosphorIcon(icon, color: Colors.grey, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
        Switch(
          value: value,
          onChanged: (val) {},
          activeColor: AppTheme.primaryColor,
        ),
      ],
    );
  }
}
