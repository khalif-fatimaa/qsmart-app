import 'package:flutter/material.dart';
import '../theme/qsmart_theme.dart';
import '../models/models.dart';
import 'dashboard_page.dart';
import 'new_session_page.dart';
import 'settings_page.dart';
import 'profile_page.dart';

class HomeShell extends StatefulWidget {
  final User currentUser;

  const HomeShell({super.key, required this.currentUser});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  int _dashboardVersion = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      DashboardPage(key: ValueKey<int>(_dashboardVersion)),
      const NewSessionPage(),
      const SettingsPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: AppColors.deepNavy,
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (int value) {
          setState(() {
            _index = value;

            // refetch the latest session from the backend.
            if (value == 0) {
              _dashboardVersion++;
            }
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.brightGold,
        unselectedItemColor: AppColors.offWhite.withOpacity(0.7),
        backgroundColor: AppColors.deepNavy,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Session',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
