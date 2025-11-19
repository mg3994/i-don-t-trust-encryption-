import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/theme/app_theme.dart';

class NotificationSettingsPage extends HookWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = useSignal(0); // 0: All, 1: Priority, 2: Silent
    final likes = useSignal(true);
    final comments = useSignal(true);
    final follows = useSignal(true);
    final mentions = useSignal(true);
    final dnd = useSignal(false);

    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (b) => const LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFFFD79A8)]).createShader(b),
          child: const Text('Notification Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                AppChip(label: 'All', selected: mode.value == 0, onTap: () => mode.value = 0, compact: true),
                const SizedBox(width: 8),
                AppChip(label: 'Priority', selected: mode.value == 1, onTap: () => mode.value = 1, compact: true),
                const SizedBox(width: 8),
                AppChip(label: 'Silent', selected: mode.value == 2, onTap: () => mode.value = 2, compact: true),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _toggleTile(Icons.notifications_active, 'Likes', likes),
          _toggleTile(Icons.chat_bubble, 'Comments', comments),
          _toggleTile(Icons.person_add, 'Follows', follows),
          _toggleTile(Icons.alternate_email, 'Mentions', mentions),
          const Divider(),
          _toggleTile(Icons.do_not_disturb_on_total_silence, 'Do Not Disturb', dnd),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Save'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _toggleTile(IconData icon, String label, Signal<bool> value) {
    return Watch((context) {
      return ListTile(
        leading: Icon(icon),
        title: Text(label),
        trailing: Switch(value: value.value, onChanged: (v) => value.value = v),
      ).animate().fadeIn(duration: 200.ms);
    });
  }
}