import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:signals_flutter/signals_flutter.dart';

class PostCard extends StatelessWidget {
  final String userName;
  final String userAvatar;
  final String timeAgo;
  final String content;
  final String? imageUrl;
  final Signal<int> likeCount;
  final Signal<bool> isLiked;
  final Signal<int> commentCount;
  final Signal<int> shareCount;

  const PostCard({
    super.key,
    required this.userName,
    required this.userAvatar,
    required this.timeAgo,
    required this.content,
    this.imageUrl,
    required this.likeCount,
    required this.isLiked,
    required this.commentCount,
    required this.shareCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                // Avatar with gradient border
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C5CE7), Color(0xFFFD79A8)],
                    ),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: theme.cardColor,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFF6C5CE7),
                      child: Text(
                        userAvatar,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userName, style: theme.textTheme.titleLarge),
                      Text(timeAgo, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                IconButton(
                  icon: PhosphorIcon(
                    PhosphorIcons.dotsThreeVertical(),
                    size: 20,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Content
            Text(content, style: theme.textTheme.bodyLarge),

            // Image if available
            if (imageUrl != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF6C5CE7).withValues(alpha: 0.3),
                        const Color(0xFFFD79A8).withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                  child: Center(
                    child: PhosphorIcon(
                      PhosphorIcons.image(),
                      size: 48,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Stats
            Watch((context) {
              return Row(
                children: [
                  _buildStat(
                    PhosphorIcons.heart(PhosphorIconsStyle.fill),
                    likeCount.value.toString(),
                    const Color(0xFFFF6B6B),
                  ),
                  const SizedBox(width: 16),
                  _buildStat(
                    PhosphorIcons.chatCircle(),
                    commentCount.value.toString(),
                    const Color(0xFF6C5CE7),
                  ),
                  const SizedBox(width: 16),
                  _buildStat(
                    PhosphorIcons.shareNetwork(),
                    shareCount.value.toString(),
                    const Color(0xFF00B894),
                  ),
                ],
              );
            }),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Action Buttons
            Watch((context) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                    context,
                    icon: isLiked.value
                        ? PhosphorIcons.heart(PhosphorIconsStyle.fill)
                        : PhosphorIcons.heart(),
                    label: 'Like',
                    color: isLiked.value ? const Color(0xFFFF6B6B) : null,
                    onTap: () {
                      isLiked.value = !isLiked.value;
                      if (isLiked.value) {
                        likeCount.value++;
                      } else {
                        likeCount.value--;
                      }
                    },
                  ),
                  _buildActionButton(
                    context,
                    icon: PhosphorIcons.chatCircle(),
                    label: 'Comment',
                    onTap: () {},
                  ),
                  _buildActionButton(
                    context,
                    icon: PhosphorIcons.shareNetwork(),
                    label: 'Share',
                    onTap: () {
                      shareCount.value++;
                    },
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildStat(PhosphorIconData icon, String count, Color color) {
    return Row(
      children: [
        PhosphorIcon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          count,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required PhosphorIconData icon,
    required String label,
    Color? color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final buttonColor = color ?? theme.iconTheme.color;

    return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                PhosphorIcon(icon, size: 20, color: buttonColor),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: buttonColor,
                  ),
                ),
              ],
            ),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 2000.ms, color: color?.withValues(alpha: 0.3));
  }
}
