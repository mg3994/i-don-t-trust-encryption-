import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/theme/app_theme.dart';

class ChatDetailPage extends HookWidget {
  final String name;
  const ChatDetailPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final filter = useSignal(0); // 0: All, 1: Media, 2: Links
    final input = useSignal('');
    final messages = useSignal<List<_Message>>([
      const _Message('Hey there! 👋', false),
      const _Message('Hi! How are you?', true),
      const _Message('Doing great, working on the app UI.', true),
      const _Message('Nice! Send me a screenshot.', false),
    ]);

    final filtered = useComputed(() {
      final f = filter.value;
      List<_Message> list = messages.value;
      if (f == 1) {
        list = list.where((m) => m.text.contains('📷') || m.text.contains('image')).toList();
      } else if (f == 2) {
        list = list.where((m) => m.text.contains('http')).toList();
      }
      return list;
    });

    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (b) => const LinearGradient(
            colors: [Color(0xFF6C5CE7), Color(0xFFFD79A8)],
          ).createShader(b),
          child: Text(
            name,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(icon: PhosphorIcon(PhosphorIcons.phone()), onPressed: () {}),
          IconButton(icon: PhosphorIcon(PhosphorIcons.videoCamera()), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                AppChip(label: 'All', selected: filter.value == 0, onTap: () => filter.value = 0, compact: true),
                const SizedBox(width: 8),
                AppChip(label: 'Media', selected: filter.value == 1, onTap: () => filter.value = 1, compact: true),
                const SizedBox(width: 8),
                AppChip(label: 'Links', selected: filter.value == 2, onTap: () => filter.value = 2, compact: true),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Watch((context) {
              final items = filtered.value;
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                reverse: true,
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final m = items[items.length - 1 - i];
                  return _bubble(context, m).animate().fadeIn(duration: 200.ms);
                },
              );
            }),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              decoration: BoxDecoration(color: Theme.of(context).cardColor, boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, -2)),
              ]),
              child: Row(
                children: [
                  IconButton(icon: PhosphorIcon(PhosphorIcons.paperclip()), onPressed: () {}),
                  Expanded(
                    child: TextField(
                      onChanged: (v) => input.value = v,
                      decoration: const InputDecoration(hintText: 'Message...', border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      final text = input.value.trim();
                      if (text.isEmpty) return;
                      final list = messages.value.toList();
                      list.add(_Message(text, true));
                      messages.value = list;
                      input.value = '';
                    },
                    child: Row(children: [PhosphorIcon(PhosphorIcons.paperPlaneRight(PhosphorIconsStyle.fill), color: Colors.white), const SizedBox(width: 8), const Text('Send')]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubble(BuildContext context, _Message m) {
    final align = m.fromMe ? Alignment.centerRight : Alignment.centerLeft;
    final bg = m.fromMe ? AppTheme.primaryColor : Theme.of(context).cardColor;
    final fg = m.fromMe ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black87;
    return Align(
      alignment: align,
      child: Container(
        margin: EdgeInsets.only(top: 8, left: m.fromMe ? 40 : 0, right: m.fromMe ? 0 : 40),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
        ),
        child: Text(m.text, style: TextStyle(color: fg, fontSize: 13)),
      ),
    );
  }
}

class _Message {
  final String text;
  final bool fromMe;
  const _Message(this.text, this.fromMe);
}