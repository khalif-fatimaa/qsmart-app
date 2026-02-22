import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import 'auth_state.dart';

/// MockRepo and the rest of the app call into this.
class QSmartApi {
  QSmartApi._();

  static final QSmartApi instance = QSmartApi._();

  /// IMPORTANT:
  /// Emulator -> host PC   = 10.0.2.2
  /// Use HTTP (NOT HTTPS) because Android does not trust your Windows dev cert.
  static const String _baseUrl = 'http://10.0.2.2:5111';
  // static const String _baseUrl = 'http://172.20.10.3:5111';

  Map<String, String> _headers(String? token, {bool jsonBody = false}) {
    final Map<String, String> headers = <String, String>{};

    if (jsonBody) {
      headers['Content-Type'] = 'application/json';
    }

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // -------------------------------------------------
  // LOGIN
  // -------------------------------------------------
  Future<void> login(String email, String password) async {
    final Uri uri = Uri.parse(
      '$_baseUrl/login?useCookies=false&useSessionCookies=false',
    );

    final http.Response resp = await http.post(
      uri,
      headers: _headers(null, jsonBody: true),
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'password': password,
        'twoFactorCode': '',
        'twoFactorRecoveryCode': '',
      }),
    );

    debugPrint('LOGIN status: ${resp.statusCode}');
    debugPrint('LOGIN body: ${resp.body}');

    if (resp.statusCode != 200) {
      throw Exception('Login failed (${resp.statusCode}): ${resp.body}');
    }

    final Map<String, dynamic> data =
        jsonDecode(resp.body) as Map<String, dynamic>;

    final String token = (data['accessToken'] ?? '') as String;
    if (token.isEmpty) {
      throw Exception('Login response missing accessToken');
    }

    AuthState.accessToken = token;
  }

  // -------------------------------------------------
  // USERS
  // -------------------------------------------------
  Future<List<User>> getUsers(String accessToken) async {
    final Uri uri = Uri.parse('$_baseUrl/api/user');

    final http.Response resp = await http.get(
      uri,
      headers: _headers(accessToken),
    );

    debugPrint('GET /api/user status: ${resp.statusCode}');

    if (resp.statusCode != 200) {
      throw Exception('Failed to fetch users: ${resp.statusCode}');
    }

    final List<dynamic> data = jsonDecode(resp.body) as List<dynamic>;
    return data
        .map((dynamic e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // -------------------------------------------------
  // SESSIONS
  // -------------------------------------------------
  Future<List<Session>> getSessionsForUser(
    String userId,
    String accessToken,
  ) async {
    final Uri uri = Uri.parse('$_baseUrl/api/session/user/$userId');

    final http.Response resp = await http.get(
      uri,
      headers: _headers(accessToken),
    );

    debugPrint(
      'GET /api/session/user/$userId status: ${resp.statusCode} ${resp.body}',
    );

    if (resp.statusCode != 200) {
      throw Exception('Failed to get sessions: ${resp.statusCode}');
    }

    final List<dynamic> data = jsonDecode(resp.body) as List<dynamic>;
    return data
        .map((dynamic e) => Session.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Session?> createSession(Session session, String accessToken) async {
    final Uri uri = Uri.parse('$_baseUrl/api/session');

    final String body = jsonEncode(<String, dynamic>{
      'SessionId': session.sessionId,
      'UserId': session.userId,
      'StartedAt': session.startedAt?.toIso8601String(),
      'Notes': session.notes,
      'Region': session.region,
      'TensionScore': session.tensionScore,
      'HeartRateBpm': session.heartRateBpm,
      'PostureAngleDegree': session.postureAngleDegree,
      'ActivityLabel': session.activityLabel,
    });

    debugPrint('POST /api/session body: $body');

    final http.Response resp = await http.post(
      uri,
      headers: _headers(accessToken, jsonBody: true),
      body: body,
    );

    debugPrint('POST /api/session status: ${resp.statusCode} ${resp.body}');

    if (resp.statusCode == 404) {
      return null;
    }

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw Exception(
        'Failed to create session: ${resp.statusCode} ${resp.body}',
      );
    }

    final Map<String, dynamic> data =
        jsonDecode(resp.body) as Map<String, dynamic>;

    return Session.fromJson(data);
  }

  // -------------------------------------------------
  // READINGS
  // -------------------------------------------------
  Future<List<Reading>> getReadingsForSession(
    String sessionId,
    String accessToken,
  ) async {
    final Uri uri = Uri.parse('$_baseUrl/api/reading/session/$sessionId');

    final http.Response resp = await http.get(
      uri,
      headers: _headers(accessToken),
    );

    debugPrint(
      'GET /api/reading/session/$sessionId status: ${resp.statusCode} ${resp.body}',
    );

    if (resp.statusCode == 404) {
      return <Reading>[];
    }

    if (resp.statusCode != 200) {
      throw Exception('Failed to get readings: ${resp.statusCode}');
    }

    final List<dynamic> data = jsonDecode(resp.body) as List<dynamic>;
    return data
        .map((dynamic e) => Reading.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> upsertReading(Reading reading, String accessToken) async {
    final Uri uri = Uri.parse('$_baseUrl/api/reading');

    final String body = jsonEncode(<String, dynamic>{
      'UserId': reading.userId,
      'SessionId': reading.sessionId,
      'CreatedAt': reading.createdAt?.toIso8601String(),
      'Region': reading.region,
      'TensionScore': reading.tensionScore,
      'HeartRateBpm': reading.heartRateBpm,
      'PostureAngleDegree': reading.postureAngleDegree,
      'ActivityLabel': reading.activityLabel,
      'RecoveryScore': reading.recoveryScore,
    });

    debugPrint('POST /api/reading body: $body');

    final http.Response resp = await http.post(
      uri,
      headers: _headers(accessToken, jsonBody: true),
      body: body,
    );

    debugPrint('POST /api/reading status: ${resp.statusCode} ${resp.body}');

    if (resp.statusCode != 200 &&
        resp.statusCode != 201 &&
        resp.statusCode != 204) {
      throw Exception(
        'Failed to upsert reading: ${resp.statusCode} ${resp.body}',
      );
    }
  }
}
