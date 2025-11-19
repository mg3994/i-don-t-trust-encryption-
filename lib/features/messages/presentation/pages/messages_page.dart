import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_chip.dart';
import 'chat_detail_page.dart';

class MessagesPage extends HookWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final search = useSignal('');
    final filter = useSignal(0);
    final conversations = useSignal<List<_Conversation>>([
      _Conversation('Sarah Johnson', 'Let’s catch up later!', 2, false),
      _Conversation('Alex Chen', 'The demo is ready.', 0, false),
      _Conversation('Maria Garcia', 'Sending the docs now.', 4, true),
      _Conversation('James Wilson', 'Great work!', 0, false),
      _Conversation('Emma Davis', 'Booked the venue.', 1, false),
    ]);

    final filtered = useComputed(() {
      final q = search.value.toLowerCase();
      final f = filter.value;
      return conversations.value.where((c) {
        final matchesQ = c.name.toLowerCase().contains(q) || c.lastMessage.toLowerCase().contains(q);
        final matchesF = f == 0 || (f == 1 && c.unread > 0) || (f == 2 && c.muted);
        return matchesQ && matchesF;
      }).toList();
    });

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF6C5CE7), Color(0xFFFD79A8)],
              ).createShader(bounds),
              child: const Text(
                'Messages',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Container(
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
                    onChanged: (v) => search.value = v,
                    decoration: InputDecoration(
                      hintText: 'Search messages...',
                      prefixIcon: PhosphorIcon(
                        PhosphorIcons.magnifyingGlass(),
                        color: AppTheme.primaryColor,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1, end: 0),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  AppChip(label: 'All', selected: filter.value == 0, onTap: () => filter.value = 0, compact: true),
                  const SizedBox(width: 8),
                  AppChip(label: 'Unread', selected: filter.value == 1, onTap: () => filter.value = 1, compact: true),
                  const SizedBox(width: 8),
                  AppChip(label: 'Muted', selected: filter.value == 2, onTap: () => filter.value = 2, compact: true),
                ],
              ),
            ),
          ),

          Watch((context) {
            final items = filtered.value;
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final c = items[index];
                return _conversationTile(
                  context,
                  c,
                  onMuteToggle: () {
                    final list = conversations.value.toList();
                    final original = list.firstWhere((e) => e.name == c.name);
                    final idx = list.indexOf(original);
                    list[idx] = original.copyWith(muted: !original.muted);
                    conversations.value = list;
                  },
                  onMarkRead: () {
                    final list = conversations.value.toList();
                    final original = list.firstWhere((e) => e.name == c.name);
                    final idx = list.indexOf(original);
                    list[idx] = original.copyWith(unread: 0);
                    conversations.value = list;
                  },
                );
              }, childCount: items.length),
            );
          }),
        ],
      ),
    );
  }

  

  Widget _conversationTile(
    BuildContext context,
    _Conversation c, {
    required VoidCallback onMuteToggle,
    required VoidCallback onMarkRead,
  }) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ChatDetailPage(name: c.name),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppTheme.primaryColor,
                  child: Text(
                    c.name[0],
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(c.name, style: theme.textTheme.titleLarge),
                          ),
                          if (c.unread > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6B6B).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${c.unread}',
                                style: const TextStyle(color: Color(0xFFFF6B6B), fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(c.lastMessage, style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: PhosphorIcon(
                    c.muted ? PhosphorIcons.bellSlash(PhosphorIconsStyle.fill) : PhosphorIcons.bell(),
                  ),
                  onPressed: onMuteToggle,
                ),
                IconButton(
                  icon: PhosphorIcon(PhosphorIcons.check()),
                  onPressed: onMarkRead,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.1, end: 0);
  }
}

class _Conversation {
  final String name;
  final String lastMessage;
  final int unread;
  final bool muted;

  const _Conversation(this.name, this.lastMessage, this.unread, this.muted);

  _Conversation copyWith({String? name, String? lastMessage, int? unread, bool? muted}) {
    return _Conversation(
      name ?? this.name,
      lastMessage ?? this.lastMessage,
      unread ?? this.unread,
      muted ?? this.muted,
    );
  }
}