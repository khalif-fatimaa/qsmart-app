// -------------------------------------
// USER
// -------------------------------------

class User {
  final String userId;
  final String name;
  final String email;
  final DateTime? createdAt;

  const User({
    required this.userId,
    required this.name,
    required this.email,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Handle a bunch of possible key names
    final dynamic id =
        json['UserID'] ?? json['user_id'] ?? json['userId'] ?? json['id'];

    final dynamic fullName = json['FullName'] ??
        json['fullName'] ??
        json['name'] ??
        json['userName'];

    final dynamic emailVal = json['Email'] ?? json['email'] ?? json['userName'];

    final dynamic createdRaw =
        json['CreatedAt'] ?? json['created_at'] ?? json['createdAt'];

    return User(
      userId: id?.toString() ?? '',
      name: (fullName ?? '').toString(),
      email: (emailVal ?? '').toString(),
      createdAt: createdRaw is String && createdRaw.isNotEmpty
          ? DateTime.tryParse(createdRaw)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'UserID': userId,
      'FullName': name,
      'Email': email,
      'CreatedAt': createdAt?.toIso8601String(),
    };
  }
}

// -------------------------------------
// SESSION
// -------------------------------------

class Session {
  final String sessionId;
  final String userId;
  final DateTime? startedAt;
  final String notes;
  final String region;
  final double tensionScore;
  final double heartRateBpm;
  final double postureAngleDegree;
  final String activityLabel;

  const Session({
    required this.sessionId,
    required this.userId,
    required this.startedAt,
    required this.notes,
    required this.region,
    required this.tensionScore,
    required this.heartRateBpm,
    required this.postureAngleDegree,
    required this.activityLabel,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    final dynamic started =
        json['StartedAt'] ?? json['started_at'] ?? json['startedAt'];

    final dynamic tension = json['TensionScore'] ??
        json['tension_score'] ??
        json['tensionScore'] ??
        0;

    final dynamic hr = json['HeartRateBpm'] ??
        json['heart_rate_bpm'] ??
        json['heartRateBpm'] ??
        0;

    final dynamic posture = json['PostureAngleDegree'] ??
        json['posture_angle_deg'] ??
        json['postureAngleDegree'] ??
        0;

    final dynamic activity = json['ActivityLabel'] ??
        json['activity_label'] ??
        json['activityLabel'];

    return Session(
      sessionId: (json['SessionID'] ??
              json['SessionId'] ??
              json['session_id'] ??
              json['sessionId'])
          .toString(),
      userId: (json['UserID'] ??
              json['UserId'] ??
              json['user_id'] ??
              json['userId'])
          .toString(),
      startedAt: started is String && started.isNotEmpty
          ? DateTime.tryParse(started)
          : null,
      notes: (json['Notes'] ?? json['notes'] ?? '').toString(),
      region: (json['Region'] ?? json['region'] ?? '').toString(),
      tensionScore: (tension as num).toDouble(),
      heartRateBpm: (hr as num).toDouble(),
      postureAngleDegree: (posture as num).toDouble(),
      activityLabel: (activity ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'SessionID': sessionId,
      'UserID': userId,
      'StartedAt': startedAt?.toIso8601String(),
      'Notes': notes,
      'Region': region,
      'TensionScore': tensionScore,
      'HeartRateBpm': heartRateBpm,
      'PostureAngleDegree': postureAngleDegree,
      'ActivityLabel': activityLabel,
    };
  }
}

// -------------------------------------
// READING
// -------------------------------------

class Reading {
  final String userId;
  final String sessionId;
  final DateTime? createdAt;
  final String region;
  final double tensionScore;
  final double heartRateBpm;
  final double postureAngleDegree;
  final String activityLabel;
  final double recoveryScore;

  const Reading({
    required this.userId,
    required this.sessionId,
    required this.createdAt,
    required this.region,
    required this.tensionScore,
    required this.heartRateBpm,
    required this.postureAngleDegree,
    required this.activityLabel,
    required this.recoveryScore,
  });

  factory Reading.fromJson(Map<String, dynamic> json) {
    final dynamic created = json['CreatedAt'] ??
        json['timestamp'] ??
        json['created_at'] ??
        json['createdAt'];

    final dynamic tension = json['TensionScore'] ??
        json['tension_score'] ??
        json['tensionScore'] ??
        0;

    final dynamic hr = json['HeartRateBpm'] ??
        json['heart_rate_bpm'] ??
        json['heartRateBpm'] ??
        0;

    final dynamic posture = json['PostureAngleDegree'] ??
        json['posture_angle_deg'] ??
        json['postureAngleDegree'] ??
        0;

    final dynamic activity = json['ActivityLabel'] ??
        json['activity_label'] ??
        json['activityLabel'];

    final dynamic recovery = json['RecoveryScore'] ??
        json['recovery_score'] ??
        json['recoveryScore'] ??
        0;

    return Reading(
      userId: (json['UserID'] ??
              json['UserId'] ??
              json['user_id'] ??
              json['userId'])
          .toString(),
      sessionId: (json['SessionID'] ??
              json['SessionId'] ??
              json['session_id'] ??
              json['sessionId'])
          .toString(),
      createdAt: created is String && created.isNotEmpty
          ? DateTime.tryParse(created)
          : null,
      region: (json['Region'] ?? json['region'] ?? '').toString(),
      tensionScore: (tension as num).toDouble(),
      heartRateBpm: (hr as num).toDouble(),
      postureAngleDegree: (posture as num).toDouble(),
      activityLabel: (activity ?? '').toString(),
      recoveryScore: (recovery as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'UserId': userId,
      'SessionId': sessionId,
      'CreatedAt': createdAt?.toIso8601String(),
      'Region': region,
      'TensionScore': tensionScore,
      'HeartRateBpm': heartRateBpm,
      'PostureAngleDegree': postureAngleDegree,
      'ActivityLabel': activityLabel,
      'RecoveryScore': recoveryScore,
    };
  }
}
