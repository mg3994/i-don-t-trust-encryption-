import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/widgets/app_chip.dart';

class CommunitiesPage extends HookWidget {
  const CommunitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selected = useSignal(0);
    final categories = ['All', 'Tech', 'Art', 'Gaming', 'Music'];
    final communities = List.generate(10, (i) => 'Community ${i + 1}');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: const Text('Communities'),
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
          SliverList.builder(
            itemCount: communities.length,
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(child: Text(communities[index][0])),
                title: Text(communities[index]),
                subtitle: const Text('Active members: 1.2k'),
                trailing: ElevatedButton(onPressed: () {}, child: const Text('Join')),
              ).animate().fadeIn(delay: (index * 40).ms);
            },
          )
        ],
      ),
    );
  }
}