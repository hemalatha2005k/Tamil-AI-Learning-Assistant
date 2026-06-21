import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/services.dart';

import '../services/api_service.dart';
import '../widgets/bottom_nav.dart';

class RephraserScreen extends StatefulWidget {
  const RephraserScreen({super.key});

  @override
  State<RephraserScreen> createState() => _RephraserScreenState();
}

class _RephraserScreenState extends State<RephraserScreen> {

  final inputController = TextEditingController();
  final FlutterTts tts = FlutterTts();

  List<String> results = [];

  bool isLoading = false;
  String? error;

  static const Color primaryColor = Color(0xFF5B5BEF);

  // 🔊 SPEAK
  Future speak(String text) async {
    await tts.setLanguage("ta-IN");
    await tts.setPitch(1.0);
    await tts.setSpeechRate(0.4);
    await tts.speak(text);
  }

  // 📋 COPY
  void copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied ✅")),
    );
  }

  // 🔥 REPHRASE (FIXED)
  void rephrase() async {

    if (inputController.text.trim().isEmpty) {
      setState(() => error = "Enter text ❗");
      return;
    }

    setState(() {
      isLoading = true;
      error = null;
      results = [];
    });

    try {
      final res = await ApiService.rephrase(
        inputController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        results = List<String>.from(res);
      });

    } catch (e) {
      setState(() {
        error = "Failed ❌";
      });
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  // 🔹 RESULT CARD
  Widget resultBox(int index, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.shade300,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [

          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.black,
            child: Text(
              "${index + 1}",
              style: const TextStyle(color: Colors.white),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15),
            ),
          ),

          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () => copy(text),
          ),

          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () => speak(text),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFE8ECFF),

      bottomNavigationBar: const BottomNav(currentIndex: 0),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // 🔙 BACK
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Content Rephraser",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text("Original Sentence"),

                const SizedBox(height: 10),

                // 🟧 INPUT
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade300,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: TextField(
                    controller: inputController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Tamil text",
                    ),
                  ),
                ),

                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                const SizedBox(height: 20),

                // 🔘 BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : rephrase,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Rephrase Content",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text("Better Versions"),

                const SizedBox(height: 10),

                // 📦 RESULTS
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: results.length,
                  itemBuilder: (_, i) => resultBox(i, results[i]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}