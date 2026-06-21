import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/storage.dart';
import 'login_screen.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {

  @override
  void initState() {
    super.initState();
    logout();
  }

  void logout() async {

    // 🔥 CLEAR TOKEN
    await StorageService.clearTokens();

    // ⏳ WAIT 2 SECONDS
    Timer(const Duration(seconds: 2), () {

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFE8ECFF),

      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(Icons.check_circle, color: Colors.green, size: 80),

            SizedBox(height: 20),

            Text(
              "Logout Successful",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text("Redirecting..."),
          ],
        ),
      ),
    );
  }
}