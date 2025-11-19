import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import 'notification_settings_page.dart';
import '../../../../core/widgets/app_chip.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedFilter = signal(0);

    final filters = ['All', 'Mentions', 'Likes', 'Comments', 'Follows'];

    final notifications = [
      _NotificationData(
        type: NotificationType.like,
        user: 'Sarah Johnson',
        action: 'liked your post',
        time: '2m ago',
        isNew: true,
      ),
      _NotificationData(
        type: NotificationType.comment,
        user: 'Alex Chen',
        action: 'commented on your post',
        content: 'This is amazing! Great work 🔥',
        time: '15m ago',
        isNew: true,
      ),
      _NotificationData(
        type: NotificationType.follow,
        user: 'Maria Garcia',
        action: 'started following you',
        time: '1h ago',
        isNew: true,
      ),
      _NotificationData(
        type: NotificationType.mention,
        user: 'James Wilson',
        action: 'mentioned you in a post',
        content: 'Check out what @you created!',
        time: '2h ago',
        isNew: false,
      ),
      _NotificationData(
        type: NotificationType.like,
        user: 'Emma Davis',
        action: 'liked your comment',
        time: '3h ago',
        isNew: false,
      ),
      _NotificationData(
        type: NotificationType.comment,
        user: 'Oliver Brown',
        action: 'replied to your comment',
        content: 'I totally agree with you!',
        time: '5h ago',
        isNew: false,
      ),
    ];

  return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            floating: true,
            snap: true,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.fromLTRB(16, 56, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: PhosphorIcon(
                            PhosphorIcons.bell(PhosphorIconsStyle.fill),
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notifications',
                                style: theme.textTheme.headlineSmall,
                              ),
                              Text(
                                '3 new updates',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: PhosphorIcon(PhosphorIcons.dotsThree()),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const NotificationSettingsPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms),
                  ],
                ),
              ),
            ),
          ),

          // Filter Pills
          SliverToBoxAdapter(
            child: SizedBox(
              height: 38,
              child: Watch((context) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedFilter.value == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: AppChip(
                        label: filters[index],
                        selected: isSelected,
                        onTap: () => selectedFilter.value = index,
                        compact: true,
                      ),
                    ).animate().fadeIn(delay: (index * 50).ms);
                  },
                );
              }),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // Notifications List
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return _buildNotificationItem(
                context,
                notifications[index],
                index,
              );
            }, childCount: notifications.length),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  

  Widget _buildNotificationItem(
    BuildContext context,
    _NotificationData notification,
    int index,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: notification.isNew
            ? AppTheme.primaryColor.withValues(alpha: 0.05)
            : theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: notification.isNew
              ? AppTheme.primaryColor.withValues(alpha: 0.2)
              : Colors.grey.withValues(alpha: 0.1),
          width: notification.isNew ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar with Icon Overlay
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppTheme.primaryColor,
                      child: Text(
                        notification.user[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _getNotificationColor(notification.type),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.scaffoldBackgroundColor,
                            width: 2,
                          ),
                        ),
                        child: PhosphorIcon(
                          _getNotificationIcon(notification.type),
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: theme.textTheme.bodyMedium,
                                children: [
                                  TextSpan(
                                    text: notification.user,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(text: ' ${notification.action}'),
                                ],
                              ),
                            ),
                          ),
                          if (notification.isNew)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF6B6B),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      if (notification.content != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            notification.content!,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          PhosphorIcon(
                            PhosphorIcons.clock(),
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            notification.time,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.2, end: 0);
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return const Color(0xFFFF6B6B);
      case NotificationType.comment:
        return const Color(0xFF6C5CE7);
      case NotificationType.follow:
        return const Color(0xFF00B894);
      case NotificationType.mention:
        return const Color(0xFFFD79A8);
    }
  }

  PhosphorIconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return PhosphorIcons.heart(PhosphorIconsStyle.fill);
      case NotificationType.comment:
        return PhosphorIcons.chatCircle(PhosphorIconsStyle.fill);
      case NotificationType.follow:
        return PhosphorIcons.userPlus(PhosphorIconsStyle.fill);
      case NotificationType.mention:
        return PhosphorIcons.at(PhosphorIconsStyle.fill);
    }
  }
}

enum NotificationType { like, comment, follow, mention }

class _NotificationData {
  final NotificationType type;
  final String user;
  final String action;
  final String? content;
  final String time;
  final bool isNew;

  _NotificationData({
    required this.type,
    required this.user,
    required this.action,
    this.content,
    required this.time,
    required this.isNew,
  });
}
