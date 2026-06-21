import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../utils/storage.dart';
import 'history_screen.dart';
import 'saved_screen.dart';
import 'change_password_screen.dart';
import 'logout_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String name = "User";
  String email = "user@gmail.com";

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    final n = await StorageService.getName();
    final e = await StorageService.getEmail();

    setState(() {
      name = n ?? "User";
      email = e ?? "user@gmail.com";
    });
  }

  String getInitial(String email) {
    if (email.isEmpty) return "?";
    return email[0].toUpperCase();
  }

  Color getColor(String text) {
    if (text.isEmpty) return Colors.grey;

    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
    ];

    return colors[text.codeUnitAt(0) % colors.length];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFE8ECFF),
      bottomNavigationBar: const BottomNav(currentIndex: 3),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [

              // 🔙 BACK ONLY (Notification removed)
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                            (route) => false,
                      );
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              const Text(
                "Profile",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              CircleAvatar(
                radius: 50,
                backgroundColor: getColor(email).withOpacity(0.2),
                child: Text(
                  getInitial(email),
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: getColor(email),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(email),

              const SizedBox(height: 20),

              menuButton(Icons.lock, "Change Password", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChangePasswordScreen(),
                  ),
                );
              }),

              menuButton(Icons.history, "History", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HistoryScreen(),
                  ),
                );
              }),

              menuButton(Icons.bookmark, "Saved Items", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SavedScreen(),
                  ),
                );
              }),

              menuButton(Icons.logout, "Logout", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LogoutScreen(),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuButton(IconData icon, String text, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.tealAccent.shade200,
        borderRadius: BorderRadius.circular(25),
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            child: Row(
              children: [
                Icon(icon),
                const SizedBox(width: 10),
                Expanded(child: Text(text)),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}