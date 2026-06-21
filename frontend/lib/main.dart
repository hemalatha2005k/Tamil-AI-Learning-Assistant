import 'package:flutter/material.dart';
import 'screens/first_page.dart';
import 'screens/home_screen.dart';
import 'utils/storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // 🔥 CHECK LOGIN STATUS
  Future<bool> isLoggedIn() async {
    final token = await StorageService.getAccessToken();
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🔥 SMART START (IMPORTANT)
      home: FutureBuilder(
        future: isLoggedIn(),
        builder: (context, snapshot) {

          // ⏳ LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // ✅ LOGGED IN → HOME
          if (snapshot.data == true) {
            return const HomeScreen();
          }

          // ❌ NOT LOGGED → FIRST PAGE
          return const FirstPage();
        },
      ),

      // ✅ ROUTES
      routes: {
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}