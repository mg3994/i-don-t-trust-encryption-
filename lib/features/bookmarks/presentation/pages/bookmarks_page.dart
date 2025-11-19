import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/widgets/app_chip.dart';

class BookmarksPage extends HookWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selected = useSignal(0);
    final categories = ['All', 'Photos', 'Videos', 'Articles'];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: const Text('Bookmarks'),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final isSelected = selected.value == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: AppChip(
                      label: categories[index],
                      selected: isSelected,
                      onTap: () => selected.value = index,
                      compact: true,
                    ),
                  ).animate().fadeIn(delay: (index * 50).ms);
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1),
              delegate: SliverChildBuilderDelegate((context, index) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.grey.withValues(alpha: 0.1), Colors.grey.withValues(alpha: 0.2)]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(child: Icon(Icons.bookmark, color: Colors.white54, size: 28)),
                ).animate().fadeIn(delay: (index * 30).ms);
              }, childCount: 12),
            ),
          )
        ],
      ),
    );
  }
}