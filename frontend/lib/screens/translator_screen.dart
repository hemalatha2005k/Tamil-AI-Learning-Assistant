import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../widgets/bottom_nav.dart';
import '../services/api_service.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {

  final inputController = TextEditingController();
  final FlutterTts tts = FlutterTts();

  String output = "";
  bool isLoading = false;
  String? error;

  static const Color primaryColor = Color(0xFF5B5BEF);

  // 🔥 TRANSLATE
  void translate() async {

    if (inputController.text.trim().isEmpty) {
      setState(() => error = "Enter text to translate");
      return;
    }

    setState(() {
      isLoading = true;
      error = null;
      output = "";
    });

    try {
      final res = await ApiService.translate(
        inputController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        output = res;
      });

      await speakTamil();

    } catch (e) {
      setState(() {
        error = "Translation failed ❌";
      });
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  // 🔊 SPEAK
  Future speakTamil() async {
    if (output.isEmpty) return;

    await tts.setLanguage("ta-IN");
    await tts.setPitch(1.0);
    await tts.setSpeechRate(0.4);
    await tts.speak(output);
  }

  // 📋 COPY
  void copyText() {
    if (output.isEmpty) return;

    Clipboard.setData(ClipboardData(text: output));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied ✅")),
    );
  }

  // 🔹 INPUT BOX
  Widget inputBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.pink.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [

          Expanded(
            child: TextField(
              controller: inputController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Enter Tanglish text",
                border: InputBorder.none,
              ),
            ),
          ),

          const Icon(Icons.edit, size: 20),
        ],
      ),
    );
  }

  // 🔹 OUTPUT BOX
  Widget outputBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.pink.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [

          Expanded(
            child: Text(
              output.isEmpty
                  ? "தமிழ் output வரும்"
                  : output,
              style: const TextStyle(fontSize: 15),
            ),
          ),

          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: speakTamil,
          ),

          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: copyText,
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
                  "Tanglish Translator",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text("Enter Tanglish Text"),

                const SizedBox(height: 15),

                inputBox(),

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
                    onPressed: isLoading ? null : translate,
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
                      "Translate",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text("Tamil Output"),

                const SizedBox(height: 10),

                outputBox(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}