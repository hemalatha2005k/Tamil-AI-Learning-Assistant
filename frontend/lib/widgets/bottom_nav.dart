import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/history_screen.dart';
import '../screens/saved_screen.dart';
import '../screens/profile_screen.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;

  const BottomNav({super.key, required this.currentIndex});

  static const Color primaryColor = Color(0xFF5B5BEF);

  void navigate(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget page;

    switch (index) {
      case 0:
        page = const HomeScreen();
        break;
      case 1:
        page = const HistoryScreen();
        break;
      case 2:
        page = const SavedScreen();
        break;
      case 3:
        page = const ProfileScreen();
        break;
      default:
        page = const HomeScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => page,
        settings: ModalRoute.of(context)!.settings, // 🔥 VERY IMPORTANT
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          navItem(context, Icons.home, "Home", 0),
          navItem(context, Icons.history, "History", 1),
          navItem(context, Icons.bookmark, "Saved", 2),
          navItem(context, Icons.person, "Profile", 3),
        ],
      ),
    );
  }

  Widget navItem(BuildContext context, IconData icon, String label, int index) {
    bool isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => navigate(context, index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: isActive ? primaryColor : Colors.black54,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? primaryColor : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}