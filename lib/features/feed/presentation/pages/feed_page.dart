import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../widgets/post_card.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Sample posts with signals
    final posts = [
      _PostData(
        userName: 'Sarah Johnson',
        userAvatar: 'SJ',
        timeAgo: '2h ago',
        content:
            'Just launched my new portfolio website! 🚀 Check it out and let me know what you think. Built with Flutter Web and it\'s blazing fast! 💜',
        imageUrl: 'placeholder',
        likeCount: signal(234),
        isLiked: signal(false),
        commentCount: signal(45),
        shareCount: signal(12),
      ),
      _PostData(
        userName: 'Alex Chen',
        userAvatar: 'AC',
        timeAgo: '5h ago',
        content:
            'Amazing sunset at the beach today 🌅 Sometimes you just need to disconnect and enjoy nature.',
        imageUrl: 'placeholder',
        likeCount: signal(567),
        isLiked: signal(true),
        commentCount: signal(89),
        shareCount: signal(34),
      ),
      _PostData(
        userName: 'Maria Garcia',
        userAvatar: 'MG',
        timeAgo: '8h ago',
        content:
            'Excited to announce that I\'ll be speaking at FlutterConf 2024! Can\'t wait to share my journey with the community. See you there! 💙',
        likeCount: signal(892),
        isLiked: signal(false),
        commentCount: signal(156),
        shareCount: signal(78),
      ),
      _PostData(
        userName: 'James Wilson',
        userAvatar: 'JW',
        timeAgo: '12h ago',
        content:
            'Coffee + Code = Perfect Morning ☕️👨‍💻 Working on something exciting!',
        imageUrl: 'placeholder',
        likeCount: signal(445),
        isLiked: signal(false),
        commentCount: signal(67),
        shareCount: signal(23),
      ),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            snap: true,
            title: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF6C5CE7), Color(0xFFFD79A8)],
              ).createShader(bounds),
              child: const Text(
                'LinkWithMentor',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: PhosphorIcon(PhosphorIcons.magnifyingGlass()),
                onPressed: () {},
              ),
              IconButton(
                icon: PhosphorIcon(PhosphorIcons.bell()),
                onPressed: () {},
              ),
            ],
          ),

          // Stories Section
          SliverToBoxAdapter(
            child: SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return _buildStoryItem(
                    context,
                    index == 0 ? 'You' : 'User ${index}',
                    index == 0,
                  ).animate().fadeIn(delay: (index * 50).ms);
                },
              ),
            ),
          ),

          // Posts
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final post = posts[index];
              return PostCard(
                userName: post.userName,
                userAvatar: post.userAvatar,
                timeAgo: post.timeAgo,
                content: post.content,
                imageUrl: post.imageUrl,
                likeCount: post.likeCount,
                isLiked: post.isLiked,
                commentCount: post.commentCount,
                shareCount: post.shareCount,
              );
            }, childCount: posts.length),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryItem(BuildContext context, String name, bool isAddStory) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isAddStory
                  ? null
                  : const LinearGradient(
                      colors: [Color(0xFF6C5CE7), Color(0xFFFD79A8)],
                    ),
            ),
            padding: const EdgeInsets.all(2),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.cardColor,
              ),
              padding: const EdgeInsets.all(2),
              child: CircleAvatar(
                backgroundColor: isAddStory
                    ? const Color(0xFF6C5CE7)
                    : theme.colorScheme.primary,
                child: isAddStory
                    ? const Icon(Icons.add, color: Colors.white)
                    : Text(
                        name[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 68,
            child: Text(
              name,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _PostData {
  final String userName;
  final String userAvatar;
  final String timeAgo;
  final String content;
  final String? imageUrl;
  final Signal<int> likeCount;
  final Signal<bool> isLiked;
  final Signal<int> commentCount;
  final Signal<int> shareCount;

  _PostData({
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
}
