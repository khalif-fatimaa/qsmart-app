import 'package:flutter/material.dart';
import 'routes.dart';
import 'theme/qsmart_theme.dart';

void main() => runApp(const QSmartApp());

class QSmartApp extends StatelessWidget {
  const QSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QSmart',
      theme: qsmartTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.login,
      routes: appRoutes,
    );
  }
}
