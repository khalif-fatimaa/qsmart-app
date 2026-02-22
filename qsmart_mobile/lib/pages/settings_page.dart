import 'package:flutter/material.dart';
import '../theme/qsmart_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = true;
  bool _notifications = true;
  bool _haptics = true;
  bool _demoCoachTips = true;

  // Simple demo tips – feels like “AI coach”, but all local.
  final List<String> _coachTips = const [
    'Your lower back has shown higher tension after heavy lifts. Try adding 5 minutes of gentle hip hinge mobility after each scan.',
    'Your tension scores are trending down. Keep spacing hard leg days at least 48 hours apart for better recovery.',
    'Neck and shoulder tension spikes on work days. A 60-second breathing reset after scans could help drop tension faster.',
    'You recover best when you sleep 7+ hours. On days with low sleep, keep intensity moderate and focus on technique.',
  ];

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _resetToDefaults() {
    setState(() {
      _darkMode = true;
      _notifications = true;
      _haptics = true;
      _demoCoachTips = true;
    });
    _showSnack('Settings reset to demo defaults');
  }

  Future<void> _confirmReset() async {
    final bool? shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset settings?'),
          content: const Text(
            'This will restore all switches back to the demo defaults. '
            'It does not affect your recovery data.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (shouldReset == true) {
      _resetToDefaults();
    }
  }

  void _showCoachTipPreview() {
    if (!_demoCoachTips) {
      _showSnack('Turn on AI coach tips to use this.');
      return;
    }

    // Simple index based on current time – avoids importing Random.
    final now = DateTime.now();
    final index = now.second % _coachTips.length;
    final tip = _coachTips[index];

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sample AI coach tip'),
          content: Text(tip),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color bg = AppColors.deepNavy;
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: AppColors.royalBlue,
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ThemePreviewCard(isDark: _darkMode),
          const SizedBox(height: 24),
          const Text(
            'General',
            style: TextStyle(
              color: AppColors.offWhite,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
              _showSnack('Theme updated (demo only)');
            },
            activeColor: AppColors.electricBlue,
            title: const Text(
              'Dark mode',
              style: TextStyle(color: AppColors.offWhite),
            ),
            subtitle: const Text(
              'Toggle between light and dark preview',
              style: TextStyle(color: AppColors.offWhite, fontSize: 12),
            ),
          ),
          SwitchListTile(
            value: _notifications,
            onChanged: (value) {
              setState(() {
                _notifications = value;
              });
              _showSnack(
                _notifications
                    ? 'Session reminders enabled (demo only)'
                    : 'Session reminders disabled',
              );
            },
            activeColor: AppColors.electricBlue,
            title: const Text(
              'Session reminders',
              style: TextStyle(color: AppColors.offWhite),
            ),
            subtitle: const Text(
              'Get a nudge after heavy workouts to run a scan',
              style: TextStyle(color: AppColors.offWhite, fontSize: 12),
            ),
          ),
          SwitchListTile(
            value: _haptics,
            onChanged: (value) {
              setState(() {
                _haptics = value;
              });
              _showSnack('Haptics ${_haptics ? 'on' : 'off'} (demo only)');
            },
            activeColor: AppColors.electricBlue,
            title: const Text(
              'Haptic feedback',
              style: TextStyle(color: AppColors.offWhite),
            ),
            subtitle: const Text(
              'Vibration on key actions (start session, save, etc.)',
              style: TextStyle(color: AppColors.offWhite, fontSize: 12),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Coaching',
            style: TextStyle(
              color: AppColors.offWhite,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            value: _demoCoachTips,
            onChanged: (value) {
              setState(() {
                _demoCoachTips = value;
              });
              _showSnack(
                  _demoCoachTips ? 'AI coach tips on' : 'AI coach tips off');
            },
            activeColor: AppColors.electricBlue,
            title: const Text(
              'AI coach tips (demo)',
              style: TextStyle(color: AppColors.offWhite),
            ),
            subtitle: const Text(
              'Show simple tips under the body map after each session',
              style: TextStyle(color: AppColors.offWhite, fontSize: 12),
            ),
          ),
          _CoachTipPreviewTile(
            enabled: _demoCoachTips,
            onPreview: _showCoachTipPreview,
          ),
          const SizedBox(height: 24),
          const Text(
            'About',
            style: TextStyle(
              color: AppColors.offWhite,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.info_outline, color: AppColors.offWhite),
            title: const Text(
              'QSmart demo build',
              style: TextStyle(color: AppColors.offWhite),
            ),
            subtitle: const Text(
              'Version 0.1.0 • Capstone prototype',
              style: TextStyle(color: AppColors.offWhite, fontSize: 12),
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.restore, color: AppColors.offWhite),
            title: const Text(
              'Reset all settings',
              style: TextStyle(color: AppColors.offWhite),
            ),
            subtitle: const Text(
              'Restore toggles back to the demo defaults',
              style: TextStyle(color: AppColors.offWhite, fontSize: 12),
            ),
            onTap: _confirmReset,
          ),
        ],
      ),
    );
  }
}

class _ThemePreviewCard extends StatelessWidget {
  final bool isDark;
  const _ThemePreviewCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final Color bg = isDark ? AppColors.deepNavy : Colors.white;
    final Color card =
        isDark ? AppColors.royalBlue : AppColors.electricBlue.withOpacity(0.1);
    final Color textPrimary = isDark ? AppColors.offWhite : AppColors.deepNavy;
    final Color textSecondary = isDark ? Colors.white70 : Colors.black54;

    return Card(
      color: bg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme preview',
              style: TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    color: isDark ? AppColors.offWhite : AppColors.deepNavy,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last Recovery Session',
                          style: TextStyle(
                            color: textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Lower back tension reduced by 18%',
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: textSecondary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isDark
                  ? 'Dark mode keeps contrast high in gyms and low light.'
                  : 'Light mode works best in clinics and bright spaces.',
              style: TextStyle(
                color: textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoachTipPreviewTile extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPreview;

  const _CoachTipPreviewTile({
    required this.enabled,
    required this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.smart_toy_outlined,
        color: enabled ? AppColors.offWhite : Colors.white38,
      ),
      title: Text(
        'Preview AI coach tip',
        style: TextStyle(
          color: enabled ? AppColors.offWhite : Colors.white54,
        ),
      ),
      subtitle: Text(
        enabled
            ? 'Tap to see the type of guidance QSmart can show after scans'
            : 'Turn AI coach tips on to preview guidance',
        style: const TextStyle(
          color: AppColors.offWhite,
          fontSize: 12,
        ),
      ),
      onTap: enabled ? onPreview : null,
    );
  }
}
