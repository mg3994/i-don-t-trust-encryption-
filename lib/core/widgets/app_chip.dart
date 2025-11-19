import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class AppChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool compact;

  const AppChip({super.key, required this.label, required this.selected, required this.onTap, this.compact = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outerRadius = compact ? 16.0 : 18.0;
    final innerRadius = compact ? 16.0 : 18.0;
    final hPadding = compact ? 12.0 : 14.0;
    final vPadding = compact ? 6.0 : 8.0;
    final fontSize = compact ? 12.0 : 13.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(outerRadius),
      child: AnimatedContainer(
        duration: 200.ms,
        curve: Curves.easeOut,
        padding: EdgeInsets.all(selected ? 1.5 : 1),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)])
              : null,
          borderRadius: BorderRadius.circular(outerRadius),
          border: selected ? null : Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: Container
        (
          padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
          decoration: BoxDecoration(
            color: selected ? AppTheme.primaryColor.withValues(alpha: 0.12) : theme.cardColor,
            borderRadius: BorderRadius.circular(innerRadius),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : theme.textTheme.bodyMedium?.color ?? Colors.grey,
            ),
          ),
        ),
      ),
    ).animate(target: selected ? 1 : 0).scale(end: const Offset(1.02, 1.02));
  }
}