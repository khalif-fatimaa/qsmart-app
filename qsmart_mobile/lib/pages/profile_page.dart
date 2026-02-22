import 'package:flutter/material.dart';
import '../services/mock_repo.dart';
import '../services/auth_state.dart';
import '../models/models.dart';
import '../theme/qsmart_theme.dart';
import '../routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _athleteType;
  late String _recoveryGoal;

  @override
  void initState() {
    super.initState();
    _athleteType = 'Lifting / Gym focused';
    _recoveryGoal = 'Reduce muscle tension';
  }

  Future<void> _editAthleteType() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select athlete type'),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'Lifting / Gym focused'),
              child: const Text('Lifting / Gym focused'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'Running / Conditioning'),
              child: const Text('Running / Conditioning'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'Court / Field sports'),
              child: const Text('Court / Field sports'),
            ),
            SimpleDialogOption(
              onPressed: () =>
                  Navigator.pop(context, 'General fitness / rehab'),
              child: const Text('General fitness / rehab'),
            ),
          ],
        );
      },
    );

    if (selected != null) {
      setState(() => _athleteType = selected);
    }
  }

  Future<void> _editRecoveryGoal() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select recovery goal'),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'Reduce muscle tension'),
              child: const Text('Reduce muscle tension'),
            ),
            SimpleDialogOption(
              onPressed: () =>
                  Navigator.pop(context, 'Improve posture & alignment'),
              child: const Text('Improve posture & alignment'),
            ),
            SimpleDialogOption(
              onPressed: () =>
                  Navigator.pop(context, 'Track recovery after training'),
              child: const Text('Track recovery after training'),
            ),
            SimpleDialogOption(
              onPressed: () =>
                  Navigator.pop(context, 'Rehab from a recent injury'),
              child: const Text('Rehab from a recent injury'),
            ),
          ],
        );
      },
    );

    if (selected != null) {
      setState(() => _recoveryGoal = selected);
    }
  }

  //  LOGOUT HANDLER
  Future<void> _logout() async {
    MockRepo.logout(); // clear tokens + user state
    if (!mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.login,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final User user = MockRepo.currentUser;

    return Scaffold(
      backgroundColor: AppColors.deepNavy,
      appBar: AppBar(
        backgroundColor: AppColors.royalBlue,
        elevation: 0,
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ProfileHeader(user: user),
            const SizedBox(height: 24),
            const _ProfileStatsCard(),
            const SizedBox(height: 24),
            _ProfileDetailsCard(
              athleteType: _athleteType,
              recoveryGoal: _recoveryGoal,
              onEditAthleteType: _editAthleteType,
              onEditRecoveryGoal: _editRecoveryGoal,
            ),
            const SizedBox(height: 24),

            //  LOGOUT BUTTON ADDED HERE
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _logout,
              child: const Text(
                "Log out",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6,
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

/// -------------------------------- UI COMPONENTS ------------------------------ ///
class _ProfileHeader extends StatelessWidget {
  final User user;
  const _ProfileHeader({required this.user});

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first.isNotEmpty ? parts.first[0] : '?';
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.royalBlue.withOpacity(0.95),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: AppColors.deepNavy.withOpacity(0.4),
              child: Text(
                _initials(user.name),
                style: const TextStyle(
                  color: AppColors.offWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.offWhite,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: const TextStyle(
                      color: AppColors.offWhite,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [AppColors.richGold, AppColors.brightGold],
                      ),
                    ),
                    child: const Text(
                      'QSmart Athlete • Demo Account',
                      style: TextStyle(
                        color: AppColors.deepNavy,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStatsCard extends StatelessWidget {
  const _ProfileStatsCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.royalBlue.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recovery Snapshot',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.offWhite, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: const [
                _StatChip(label: 'Total Sessions', value: '8'),
                SizedBox(width: 12),
                _StatChip(label: 'Avg Tension Score', value: '62'),
                SizedBox(width: 12),
                _StatChip(label: 'Best Recovery Score', value: '82'),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Stay consistent with scans to monitor fatigue trends.',
              style: TextStyle(color: AppColors.offWhite, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.deepNavy.withOpacity(0.8),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    color: AppColors.offWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            const SizedBox(height: 4),
            Text(label,
                style:
                    const TextStyle(color: AppColors.offWhite, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _ProfileDetailsCard extends StatelessWidget {
  final String athleteType;
  final String recoveryGoal;
  final VoidCallback onEditAthleteType;
  final VoidCallback onEditRecoveryGoal;

  const _ProfileDetailsCard({
    required this.athleteType,
    required this.recoveryGoal,
    required this.onEditAthleteType,
    required this.onEditRecoveryGoal,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.deepNavy.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      child: Column(
        children: [
          ListTile(
            onTap: onEditAthleteType,
            leading:
                const Icon(Icons.person_outline, color: AppColors.offWhite),
            title: const Text('Athlete Type',
                style: TextStyle(color: AppColors.offWhite)),
            subtitle: Text(athleteType,
                style:
                    const TextStyle(color: AppColors.offWhite, fontSize: 12)),
            trailing:
                const Icon(Icons.edit, color: AppColors.offWhite, size: 18),
          ),
          const Divider(height: 1, color: Colors.white24),
          ListTile(
            onTap: onEditRecoveryGoal,
            leading: const Icon(Icons.flag_outlined, color: AppColors.offWhite),
            title: const Text('Recovery Goal',
                style: TextStyle(color: AppColors.offWhite)),
            subtitle: Text(recoveryGoal,
                style:
                    const TextStyle(color: AppColors.offWhite, fontSize: 12)),
            trailing:
                const Icon(Icons.edit, color: AppColors.offWhite, size: 18),
          ),
        ],
      ),
    );
  }
}
