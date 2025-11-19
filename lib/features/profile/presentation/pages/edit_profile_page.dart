import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_theme.dart';

class EditProfilePage extends HookWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final name = useSignal('John Doe');
    final username = useSignal('johndoe');
    final bio = useSignal('Flutter Developer 💙 | Tech Enthusiast | Coffee Lover ☕');
    final valid = useComputed(() => name.value.trim().isNotEmpty && username.value.trim().isNotEmpty);

    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (b) => const LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFFFD79A8)]).createShader(b),
          child: const Text('Edit Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(radius: 40, backgroundColor: AppTheme.primaryColor, child: const Text('JD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: AppTheme.secondaryColor, shape: BoxShape.circle),
                    child: PhosphorIcon(PhosphorIcons.camera(), color: Colors.white, size: 16),
                  ),
                )
              ],
            ),
          ).animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 16),
          _label('Name'),
          _field(initial: name.value, onChanged: (v) => name.value = v),
          const SizedBox(height: 12),
          _label('Username'),
          _field(initial: username.value, onChanged: (v) => username.value = v, prefix: '@'),
          const SizedBox(height: 12),
          _label('Bio'),
          _field(initial: bio.value, onChanged: (v) => bio.value = v, maxLines: 3),
          const SizedBox(height: 20),
          Watch((context) {
            final enabled = valid.value;
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: enabled ? AppTheme.primaryColor : Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: enabled
                  ? () {
                      Navigator.of(context).pop();
                    }
                  : null,
              child: const Text('Save Changes'),
            ).animate().fadeIn(duration: 200.ms);
          }),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      );

  Widget _field({required String initial, required ValueChanged<String> onChanged, int maxLines = 1, String? prefix}) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)]),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)),
        child: TextField(
          controller: TextEditingController(text: initial),
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixText: prefix,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ),
    );
  }
}