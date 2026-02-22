import 'package:flutter/material.dart';
import 'pages/body_scan_screen.dart';
import 'pages/home_shell.dart';
import 'pages/login_page.dart';
import 'pages/new_session_page.dart';
import 'models/models.dart';

class Routes {
  static const String login = '/';
  static const String home = '/home';
  static const String newSession = '/new_session';
  static const String bodyScanner = '/body_scanner';
}

final Map<String, WidgetBuilder> appRoutes = {
  Routes.login: (context) => const LoginPage(),
  Routes.newSession: (context) => const NewSessionPage(),
  Routes.bodyScanner: (context) => const BodyScanScreen(),
  Routes.home: (context) {
    final Object? args = ModalRoute.of(context)!.settings.arguments;
    final user = args as User;
    return HomeShell(currentUser: user);
  },
};
