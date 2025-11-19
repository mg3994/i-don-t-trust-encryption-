import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';

class SettingsPage extends HookWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notificationsEnabled = useSignal(true);
    final privateAccount = useSignal(false);
    final autoplayVideos = useSignal(true);
    final dataSaver = useSignal(false);
    final username = useSignal('johndoe');
    final bio = useSignal('Flutter Developer');
    final isFormValid = useComputed(
      () => username.value.trim().isNotEmpty && bio.value.length <= 160,
    );

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
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            actions: [
              Watch((context) {
                return Opacity(
                  opacity: isFormValid.value ? 1 : 0.5,
                  child: TextButton(
                    onPressed: isFormValid.value ? () {} : null,
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.1),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: PhosphorIcon(
                              PhosphorIcons.user(PhosphorIconsStyle.fill),
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text('Profile', style: theme.textTheme.titleLarge),
                        ],
                      ).animate().fadeIn(duration: 300.ms),
                      const SizedBox(height: 12),
                      TextField(
                        controller: useTextEditingController(text: username.value),
                        onChanged: (v) => username.value = v,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: useTextEditingController(text: bio.value),
                        onChanged: (v) => bio.value = v,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Bio',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Watch((context) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${bio.value.length}/160',
                            style: theme.textTheme.bodySmall,
                          ),
                        );
                      }),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 16),

                Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      _settingTile(
                        context,
                        icon: PhosphorIcons.bell(),
                        label: 'Notifications',
                        value: notificationsEnabled.value,
                        onChanged: (v) => notificationsEnabled.value = v,
                      ),
                      _divider(),
                      _settingTile(
                        context,
                        icon: PhosphorIcons.lock(),
                        label: 'Private account',
                        value: privateAccount.value,
                        onChanged: (v) => privateAccount.value = v,
                      ),
                      _divider(),
                      _settingTile(
                        context,
                        icon: PhosphorIcons.videoCamera(),
                        label: 'Autoplay videos',
                        value: autoplayVideos.value,
                        onChanged: (v) => autoplayVideos.value = v,
                      ),
                      _divider(),
                      _settingTile(
                        context,
                        icon: PhosphorIcons.cloudArrowDown(),
                        label: 'Data saver',
                        value: dataSaver.value,
                        onChanged: (v) => dataSaver.value = v,
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingTile(
    BuildContext context, {
    required PhosphorIconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor.withValues(alpha: 0.2),
                  AppTheme.secondaryColor.withValues(alpha: 0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: PhosphorIcon(icon, size: 18, color: AppTheme.primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: theme.textTheme.titleLarge)),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Divider(height: 1);
  }
}