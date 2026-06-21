import 'package:flutter/material.dart';

import 'translator_screen.dart';
import 'history_screen.dart';
import 'rephraser_screen.dart';
import 'sentence_builder_screen.dart';
import '../widgets/bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  static const Color bgColor = Color(0xFFE8ECFF);

  // 🔹 FEATURE CARD
  Widget featureCard(String title, String img, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [

          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 6),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                img,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 8),

          SizedBox(
            width: 120,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: bgColor,

      // ✅ Bottom Nav
      bottomNavigationBar: const BottomNav(currentIndex: 0),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: SingleChildScrollView(
            child: Column(
              children: [

                // ❌ REMOVED ICON ROW

                const SizedBox(height: 10),

                // 🟣 TITLE
                const Text(
                  "Vanakkam! 🙏",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Tamil AI Learning Assistant",
                  style: TextStyle(color: Colors.black54),
                ),

                const SizedBox(height: 20),

                // 📚 BOOK IMAGE
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/images/book_glow.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Choose a Feature",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),

                const SizedBox(height: 20),

                // 🔲 FEATURES
                Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                        featureCard(
                          "Tanglish\nTranslator",
                          "assets/images/translator.png",
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TranslatorScreen(),
                              ),
                            );
                          },
                        ),

                        featureCard(
                          "Content Rephraser",
                          "assets/images/rephraser.png",
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RephraserScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                        featureCard(
                          "Sentence\nBuilder",
                          "assets/images/sentence.png",
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SentenceBuilderScreen(),
                              ),
                            );
                          },
                        ),

                        featureCard(
                          "History",
                          "assets/images/history.png",
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HistoryScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}