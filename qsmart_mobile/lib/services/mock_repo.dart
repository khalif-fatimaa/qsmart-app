import 'dart:math';
import '../models/models.dart';
import 'auth_state.dart';
import 'qsmart_api.dart';

class MockRepo {
  // Fallback demo user if someone hits screens without logging in first.
  static const User _demoUser = User(
    userId: 'demo-user',
    name: 'Demo Athlete',
    email: 'demo@example.com',
    createdAt: null,
  );

  static User get currentUser => AuthState.currentUser ?? _demoUser;

  static final QSmartApi _api = QSmartApi.instance;
  static final Random _rng = Random();

  // Used only for generating synthetic readings
  static const List<String> _regionPool = <String>[
    'neck',
    'left_shoulder',
    'right_shoulder',
    'upper_back',
    'lower_back',
    'core',
    'chest',
    'glutes',
    'left_quad',
    'right_quad',
    'left_hamstring',
    'right_hamstring',
    'left_calf',
    'right_calf',
  ];

  // ---------------------------
  // SESSION QUERIES
  // ---------------------------

  static Future<Session?> fetchLastSessionForCurrentUser() async {
    if (!AuthState.isAuthenticated) {
      return null;
    }

    final String token = AuthState.accessToken!;
    final List<Session> sessions =
        await _api.getSessionsForUser(currentUser.userId, token);

    if (sessions.isEmpty) {
      return null;
    }

    sessions.sort(
      (Session a, Session b) =>
          _nullSafeDate(b.startedAt).compareTo(_nullSafeDate(a.startedAt)),
    );

    return sessions.first;
  }

  static Future<List<Session>> fetchAllSessionsForUser() async {
    if (!AuthState.isAuthenticated) {
      return <Session>[];
    }

    final String token = AuthState.accessToken!;
    final List<Session> sessions =
        await _api.getSessionsForUser(currentUser.userId, token);

    sessions.sort(
      (Session a, Session b) =>
          _nullSafeDate(b.startedAt).compareTo(_nullSafeDate(a.startedAt)),
    );

    return sessions;
  }

  // ---------------------------
  // READING QUERIES
  // ---------------------------

  static Future<List<Reading>> fetchReadingsBySession(String sessionId) async {
    if (!AuthState.isAuthenticated) {
      return <Reading>[];
    }

    final String token = AuthState.accessToken!;
    final List<Reading> readings =
        await _api.getReadingsForSession(sessionId, token);

    readings.sort(
      (Reading a, Reading b) =>
          _nullSafeDate(a.createdAt).compareTo(_nullSafeDate(b.createdAt)),
    );

    return readings;
  }

  // ---------------------------
  // SAVE NEW SESSION + AUTO-READINGS (BACKEND ONLY)
  // ---------------------------

  static Future<Session> saveNewSession(Session session) async {
    if (!AuthState.isAuthenticated) {
      throw Exception('Must be logged in to start a session.');
    }

    final String token = AuthState.accessToken!;

    // Ensure we always use the authenticated userId.
    final Session actualSession = Session(
      sessionId: session.sessionId,
      userId: currentUser.userId,
      startedAt: session.startedAt,
      notes: session.notes,
      region: session.region,
      tensionScore: session.tensionScore,
      heartRateBpm: session.heartRateBpm,
      postureAngleDegree: session.postureAngleDegree,
      activityLabel: session.activityLabel,
    );

    // 1) Create the session in the backend
    final Session? created = await _api.createSession(actualSession, token);
    final Session persisted = created ?? actualSession;

    // 2) Generate 3 synthetic readings and POST them to backend
    final List<String> regions = _pickDistinctRegions(3);

    for (final String region in regions) {
      final double tension = 30 + _rng.nextDouble() * 65; // 30..95
      final double heartRate = 60 + _rng.nextDouble() * 55; // 60..115
      final double angle = _rng.nextDouble() * 25; // 0..25 degrees
      final double recovery = 40 + _rng.nextDouble() * 50; // 40..90

      final Reading reading = Reading(
        userId: persisted.userId,
        sessionId: persisted.sessionId,
        createdAt: (persisted.startedAt ?? DateTime.now())
            .add(const Duration(minutes: 1)),
        region: region,
        tensionScore: double.parse(tension.toStringAsFixed(1)),
        heartRateBpm: double.parse(heartRate.toStringAsFixed(1)),
        postureAngleDegree: double.parse(angle.toStringAsFixed(1)),
        activityLabel: persisted.activityLabel,
        recoveryScore: double.parse(recovery.toStringAsFixed(1)),
      );

      await _api.upsertReading(reading, token);
    }

    // Return the actual session we just created and used for readings.
    return persisted;
  }

  // ---------------------------
  // ACCOUNT / PROFILE
  // ---------------------------

  static Future<void> logout() async {
    AuthState.logout(); // clears token + currentUser
  }

  // ---------------------------
  // Helpers
  // ---------------------------

  static List<String> _pickDistinctRegions(int count) {
    final List<String> pool = List<String>.from(_regionPool)..shuffle(_rng);
    return pool.take(count).toList();
  }

  static DateTime _nullSafeDate(DateTime? value) {
    return value ?? DateTime.fromMillisecondsSinceEpoch(0);
  }
}
