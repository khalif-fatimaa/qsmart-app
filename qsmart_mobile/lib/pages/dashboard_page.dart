import 'package:flutter/material.dart';
import '../services/mock_repo.dart';
import '../models/models.dart';
import '../theme/qsmart_theme.dart';
import '../routes.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Session?> _futureLast;

  @override
  void initState() {
    super.initState();
    _futureLast = MockRepo.fetchLastSessionForCurrentUser();
  }

  void _reloadLastSession() {
    setState(() {
      _futureLast = MockRepo.fetchLastSessionForCurrentUser();
    });
  }

  void _onStartNewSession() {
    Navigator.of(context).pushNamed(Routes.newSession).then((_) {
      // when user eventually comes back from NewSession/Scanner,
      // reload the last session data
      _reloadLastSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.royalBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GreetingHeader(name: MockRepo.currentUser.name),
              const SizedBox(height: 16),
              FutureBuilder<Session?>(
                future: _futureLast,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final session = snap.data;
                  if (session == null) return _emptyState();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LastSessionCard(session: session),
                      const SizedBox(height: 12),
                      const _ViewMapButton(),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _onStartNewSession,
                  icon: const Icon(Icons.add),
                  label: const Text('Start New Session'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.electricBlue,
                    foregroundColor: AppColors.offWhite,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Card(
      color: AppColors.deepNavy,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.favorite_border, size: 40, color: AppColors.offWhite),
            SizedBox(height: 12),
            Text(
              'No sessions yet. You can start a new session from the button below.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.offWhite),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ViewMapButton extends StatelessWidget {
  const _ViewMapButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.of(context).pushNamed(Routes.bodyScanner);
        },
        icon: const Icon(Icons.map_outlined),
        label: const Text('View Body Tension Map'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.offWhite,
          side: const BorderSide(color: AppColors.electricBlue, width: 2),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  final String name;
  const _GreetingHeader({required this.name});

  String _initials(String s) {
    final parts = s.trim().split(' ');
    if (parts.length == 1) {
      return parts.first.isEmpty ? '?' : parts.first[0].toUpperCase();
    }
    final a = parts[0].isNotEmpty ? parts[0][0] : 'A';
    final b = parts[1].isNotEmpty ? parts[1][0] : 'C';
    return '${a.toUpperCase()}${b.toUpperCase()}';
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 18) return 'Good afternoon,';
    return 'Good evening,';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.deepNavy.withOpacity(0.25),
          child: Text(
            _initials(name),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.offWhite,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _greeting(),
              style: const TextStyle(color: AppColors.offWhite, fontSize: 12),
            ),
            Text(
              name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.offWhite,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none),
          color: AppColors.offWhite,
          tooltip: 'Notifications',
        ),
      ],
    );
  }
}

class _LastSessionCard extends StatefulWidget {
  final Session session;
  const _LastSessionCard({required this.session});

  @override
  State<_LastSessionCard> createState() => _LastSessionCardState();
}

class _LastSessionCardState extends State<_LastSessionCard> {
  bool _loading = true;
  List<Reading> _readings = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant _LastSessionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.session.sessionId != widget.session.sessionId) {
      setState(() {
        _loading = true;
        _readings = [];
      });
      _load();
    }
  }

  Future<void> _load() async {
    final data =
        await MockRepo.fetchReadingsBySession(widget.session.sessionId);
    setState(() {
      _readings = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.session;

    final topThree = (List<Reading>.from(_readings)
          ..sort((a, b) => b.tensionScore.compareTo(a.tensionScore)))
        .take(3)
        .toList();

    return Card(
      color: AppColors.royalBlue.withOpacity(0.9),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _loading
            ? const LinearProgressIndicator()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.event, color: AppColors.offWhite),
                      const SizedBox(width: 8),
                      Text(
                        'Last Session',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppColors.offWhite,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    icon: Icons.schedule,
                    label: _formatDate(s.startedAt),
                  ),
                  _InfoRow(
                    icon: Icons.local_fire_department,
                    label:
                        'Pain / Tension Score: ${s.tensionScore.toStringAsFixed(1)}',
                  ),
                  _InfoRow(
                    icon: Icons.straighten,
                    label:
                        'Posture Angle: ${s.postureAngleDegree.toStringAsFixed(1)}°',
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Colors.white24, height: 24),
                  Text(
                    'Top Areas',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.offWhite,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 6),
                  for (final r in topThree) ...[
                    _RegionCard(reading: r),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
      ),
    );
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) {
      return 'Not recorded';
    }
    return '${dt.year}-${_two(dt.month)}-${_two(dt.day)} '
        '${_two(dt.hour)}:${_two(dt.minute)}';
  }

  String _two(int n) => n < 10 ? '0$n' : '$n';
}

class _RegionCard extends StatelessWidget {
  final Reading reading;
  const _RegionCard({required this.reading});

  String _prettyRegion(String s) {
    return s
        .split('_')
        .map((p) => p.isEmpty
            ? ''
            : '${p[0].toUpperCase()}${p.substring(1).toLowerCase()}')
        .join(' ');
  }

  String getTensionLabel(double score) {
    if (score < 50) return 'Low Tension';
    if (score < 70) return 'Moderate Tension';
    return 'High Tension';
  }

  Color getTensionColor(double score) {
    if (score < 50) return Colors.greenAccent;
    if (score < 70) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    final level = getTensionLabel(reading.tensionScore);
    final color = getTensionColor(reading.tensionScore);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: AppColors.royalBlue.withOpacity(0.7),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _prettyRegion(reading.region),
                  style: const TextStyle(
                    color: AppColors.offWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    border: Border.all(color: color, width: 0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    level,
                    style: TextStyle(
                      fontSize: 10,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Muscle Tension',
              style: TextStyle(fontSize: 12, color: AppColors.offWhite),
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (reading.tensionScore.clamp(0, 100)) / 100.0,
                backgroundColor: Colors.white12,
                color: color,
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _IconLabel(icon: Icons.favorite, label: '80 bpm'),
                _IconLabel(
                    icon: Icons.accessibility_new, label: 'Body Angle: 20°'),
                _IconLabel(icon: Icons.recycling, label: 'Recovery: 0.72'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IconLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  const _IconLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.offWhite, size: 14),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(color: AppColors.offWhite, fontSize: 11),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: AppColors.electricBlue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.offWhite),
            ),
          ),
        ],
      ),
    );
  }
}
