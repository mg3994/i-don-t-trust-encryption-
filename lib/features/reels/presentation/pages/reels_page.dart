import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';

class ReelsPage extends HookWidget {
  const ReelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = usePageController();
    final index = useSignal(0);
    final items = List.generate(8, (i) => i);

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: controller,
            scrollDirection: Axis.vertical,
            onPageChanged: (i) => index.value = i,
            itemCount: items.length,
            itemBuilder: (context, i) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF6C5CE7).withValues(alpha: 0.6 - (i % 3) * 0.1),
                      const Color(0xFFFD79A8).withValues(alpha: 0.6 - (i % 3) * 0.1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Reel ${i + 1}',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ).animate().fadeIn(duration: 400.ms),
                ),
              );
            },
          ),
          Positioned(
            right: 16,
            bottom: 32,
            child: Column(
              children: [
                _circleButton(Icons.favorite, AppTheme.accentColor),
                const SizedBox(height: 12),
                _circleButton(Icons.chat_bubble, AppTheme.primaryColor),
                const SizedBox(height: 12),
                _circleButton(Icons.share, const Color(0xFFFF6B6B)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _circleButton(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.8), shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white),
    );
  }
}