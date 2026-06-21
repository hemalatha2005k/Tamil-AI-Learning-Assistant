import 'package:flutter/material.dart';
import 'login_screen.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFAFC0F7),

      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 30),

          decoration: BoxDecoration(
            color: const Color(0xFFB9C6F8).withOpacity(0.8),
            borderRadius: BorderRadius.circular(40),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // 🔴 TITLE
              const Text(
                "Tamil AI Learning Assistant",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),

              const SizedBox(height: 25),

              // 🧠 LOGO (use your transparent image)
              Image.asset(
                "assets/images/brain.png",
                height: 140,
              ),

              const SizedBox(height: 20),

              // 🟣 APP NAME
              const Text(
                "தமிழ் AI",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.tealAccent,
                ),
              ),

              const SizedBox(height: 25),

              // ✨ QUOTES
              const Text(
                '"Tanglish in, Tamil out."\n'
                    '"Connect. Convert.\nConverse in Tamil."\n'
                    '"Type easy. Talk Tamil."',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.purple,
                ),
              ),

              const SizedBox(height: 40),

              // 🔵 LOGIN BUTTON (UPDATED)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B5BD7),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),

                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}