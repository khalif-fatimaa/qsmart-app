import 'dart:async';
import '../models/models.dart';
import '../models/tension_display_point.dart';
import 'mock_repo.dart';

class BodyMapService {
  // Normalized (0–1) coordinates over the body silhouettes.
  // These coordinates assume the same relative proportions for
  // the front and back reference images.
  static const Map<String, ({double x, double y})> _regionCoordinates = {
    // Upper body – front
    'neck': (x: 0.50, y: 0.18),
    'left_shoulder': (x: 0.72, y: 0.23),
    'right_shoulder': (x: 0.29, y: 0.23),
    'core': (x: 0.50, y: 0.40),

    // Chest split (left / right)
    'chest_left': (x: 0.60, y: 0.26),
    'chest_right': (x: 0.38, y: 0.26),
    'chest': (x: 0.45, y: 0.30), // generic fallback

    // Upper / lower back (back view)
    'upper_back': (x: 0.50, y: 0.25),
    'lower_back_center': (x: 0.50, y: 0.42),
    'lower_back': (x: 0.50, y: 0.40),

    // Glutes (back view)
    'glute_left': (x: 0.40, y: 0.49),
    'glute_right': (x: 0.60, y: 0.49),
    'glutes': (x: 0.45, y: 0.53),

    // Legs – front (quads / calves)
    'left_quad': (x: 0.60, y: 0.60),
    'right_quad': (x: 0.38, y: 0.60),
    'left_calf': (x: 0.60, y: 0.78),
    'right_calf': (x: 0.40, y: 0.78),

    // Legs – back (hamstrings)
    'left_hamstring': (x: 0.38, y: 0.62),
    'right_hamstring': (x: 0.60, y: 0.62),
  };

  // Which side of the body each region should appear on.
  static const Map<String, BodySide> _regionSides = {
    // Front
    'neck': BodySide.front,
    'left_shoulder': BodySide.front,
    'right_shoulder': BodySide.front,
    'core': BodySide.front,
    'chest_left': BodySide.front,
    'chest_right': BodySide.front,
    'chest': BodySide.front,
    'left_quad': BodySide.front,
    'right_quad': BodySide.front,
    'left_calf': BodySide.front,
    'right_calf': BodySide.front,

    // Back
    'upper_back': BodySide.back,
    'lower_back_center': BodySide.back,
    'lower_back': BodySide.back,
    'glute_left': BodySide.back,
    'glute_right': BodySide.back,
    'glutes': BodySide.back,
    'left_hamstring': BodySide.back,
    'right_hamstring': BodySide.back,
  };

  static const double _minTension = 30.0;
  static const double _maxTension = 95.0;
  static const double _tensionRange = _maxTension - _minTension;

  static double _normalizeTension(double? rawScore) {
    if (rawScore == null) {
      return 0.0;
    }
    final double score = rawScore.clamp(_minTension, _maxTension);
    return (score - _minTension) / _tensionRange;
  }

  /// Small helper so we can easily add multiple dots for one region.
  void _addPoint(
    List<TensionDisplayPoint> list,
    String regionKey,
    Reading reading,
  ) {
    final coords = _regionCoordinates[regionKey];
    if (coords == null) return;

    final BodySide side = _regionSides[regionKey] ?? BodySide.front;

    list.add(
      TensionDisplayPoint(
        region: regionKey,
        xRatio: coords.x,
        yRatio: coords.y,
        severity: _normalizeTension(reading.tensionScore),
        side: side,
      ),
    );
  }

  /// Get tension points for a specific sessionId.
  Future<List<TensionDisplayPoint>> fetchTensionPointsForSession(
    String sessionId,
  ) async {
    final List<Reading> readings =
        await MockRepo.fetchReadingsBySession(sessionId);

    // Key = "regionKey-side" (e.g. "chest_left-front")
    final Map<String, TensionDisplayPoint> slots = {};

    void putPoint(String regionKey, Reading reading) {
      final coords = _regionCoordinates[regionKey];
      if (coords == null) return;

      final BodySide side = _regionSides[regionKey] ?? BodySide.front;
      final double severity = _normalizeTension(reading.tensionScore);

      final String slotKey = '$regionKey-${side.name}';
      final existing = slots[slotKey];

      // keep only the highest severity if multiple readings hit same slot
      if (existing == null || severity > existing.severity) {
        slots[slotKey] = TensionDisplayPoint(
          region: regionKey,
          xRatio: coords.x,
          yRatio: coords.y,
          severity: severity,
          side: side,
        );
      }
    }

    for (final Reading reading in readings) {
      switch (reading.region) {
        case 'chest':
          putPoint('chest_left', reading);
          putPoint('chest_right', reading);
          break;

        case 'lower_back':
          putPoint('lower_back_center', reading);
          break;

        case 'glutes':
          putPoint('glute_left', reading);
          putPoint('glute_right', reading);
          break;

        default:
          // generic 1:1 mapping
          putPoint(reading.region, reading);
          break;
      }
    }

    return slots.values.toList();
  }

  /// Fallback: get points for the most recent session for the current user.
  Future<List<TensionDisplayPoint>> fetchTensionPointsForLastSession() async {
    final Session? lastSession =
        await MockRepo.fetchLastSessionForCurrentUser();

    if (lastSession == null) {
      return <TensionDisplayPoint>[];
    }

    // Re-use the session-based helper.
    return fetchTensionPointsForSession(lastSession.sessionId);
  }
}
