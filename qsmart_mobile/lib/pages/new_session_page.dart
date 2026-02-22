import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/mock_repo.dart';
import '../theme/qsmart_theme.dart';
import '../routes.dart';

class NewSessionPage extends StatefulWidget {
  const NewSessionPage({super.key});

  @override
  State<NewSessionPage> createState() => _NewSessionPageState();
}

class _NewSessionPageState extends State<NewSessionPage> {
  double _tensionScore = 50;
  double _postureAngle = 20;
  bool _saving = false;
  final TextEditingController _notesController = TextEditingController();
  String _activityLabel = 'Manual Entry';

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveSession() async {
    if (_saving) return;

    setState(() => _saving = true);

    // Safe default heart rate for backend validation.
    const double defaultHeartRate = 70;

    final Session newSession = Session(
      sessionId: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: MockRepo.currentUser.userId,
      startedAt: DateTime.now(),
      notes: _notesController.text.trim().isEmpty
          ? 'No notes provided.'
          : _notesController.text.trim(),
      region: 'full_body',
      tensionScore: _tensionScore,
      heartRateBpm: defaultHeartRate,
      postureAngleDegree: _postureAngle,
      activityLabel: _activityLabel,
    );

    Session persisted;
    try {
      persisted = await MockRepo.saveNewSession(newSession);
    } catch (e) {
      if (!mounted) return;

      setState(() => _saving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to start session: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (!mounted) return;

    setState(() => _saving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New session started successfully!'),
      ),
    );

    Navigator.of(context).pushNamed(
      Routes.bodyScanner,
      arguments: persisted.sessionId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.royalBlue,
      appBar: AppBar(
        backgroundColor: AppColors.deepNavy,
        title: const Text('Start New Session'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Customize your session:',
                style: TextStyle(
                  color: AppColors.offWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              // Activity label dropdown
              const Text(
                'Activity Type',
                style: TextStyle(color: AppColors.offWhite, fontSize: 14),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _activityLabel,
                dropdownColor: AppColors.royalBlue,
                items: const [
                  DropdownMenuItem(
                    value: 'Manual Entry',
                    child: Text('Manual Entry'),
                  ),
                  DropdownMenuItem(
                    value: 'Stretch Routine',
                    child: Text('Stretch Routine'),
                  ),
                  DropdownMenuItem(
                    value: 'Office Break',
                    child: Text('Office Break'),
                  ),
                  DropdownMenuItem(
                    value: 'Workout Recovery',
                    child: Text('Workout Recovery'),
                  ),
                ],
                onChanged: (value) =>
                    setState(() => _activityLabel = value ?? 'Manual Entry'),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: const TextStyle(color: AppColors.offWhite),
              ),
              const SizedBox(height: 30),

              // Tension slider
              Text(
                'Pain / Tension Score: ${_tensionScore.toStringAsFixed(1)}',
                style: const TextStyle(color: AppColors.offWhite),
              ),
              Slider(
                value: _tensionScore,
                min: 0,
                max: 100,
                divisions: 100,
                label: _tensionScore.toStringAsFixed(1),
                activeColor: AppColors.electricBlue,
                onChanged: (v) => setState(() => _tensionScore = v),
              ),
              const SizedBox(height: 25),

              // Posture slider
              Text(
                'Posture Angle: ${_postureAngle.toStringAsFixed(1)}°',
                style: const TextStyle(color: AppColors.offWhite),
              ),
              Slider(
                value: _postureAngle,
                min: 0,
                max: 90,
                divisions: 90,
                label: '${_postureAngle.toStringAsFixed(1)}°',
                activeColor: AppColors.electricBlue,
                onChanged: (v) => setState(() => _postureAngle = v),
              ),
              const SizedBox(height: 25),

              // Notes input
              const Text(
                'Notes (optional)',
                style: TextStyle(color: AppColors.offWhite, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                maxLines: 3,
                style: const TextStyle(color: AppColors.offWhite),
                decoration: InputDecoration(
                  hintText: 'Add any observations or comments...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saving ? null : _saveSession,
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.play_arrow),
                  label: Text(
                    _saving ? 'Starting...' : 'Start Session',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.offWhite,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.electricBlue,
                    foregroundColor: AppColors.offWhite,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
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
}
