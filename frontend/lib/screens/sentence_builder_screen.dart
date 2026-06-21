import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../services/api_service.dart';
import '../widgets/bottom_nav.dart';

class SentenceBuilderScreen extends StatefulWidget {
  const SentenceBuilderScreen({super.key});

  @override
  State<SentenceBuilderScreen> createState() =>
      _SentenceBuilderScreenState();
}

class _SentenceBuilderScreenState extends State<SentenceBuilderScreen> {

  final nounController = TextEditingController();
  final verbController = TextEditingController();

  String tense = "past";
  String gender = "any";

  List<String> results = [];

  bool isLoading = false;
  String? error;

  static const Color primaryColor = Color(0xFF5B5BEF);

  // 🔊 TTS ENGINE
  final FlutterTts tts = FlutterTts();

  @override
  void initState() {
    super.initState();

    // 🔥 Tamil Voice Setup
    tts.setLanguage("ta-IN"); // Tamil
    tts.setSpeechRate(0.4);
    tts.setPitch(1.0);
  }

  // 🔊 SPEAK FUNCTION
  Future speak(String text) async {
    await tts.stop();
    await tts.speak(text);
  }

  // 🔥 GENERATE
  void generate() async {

    if (nounController.text.trim().isEmpty ||
        verbController.text.trim().isEmpty) {
      setState(() => error = "Fill all fields ❗");
      return;
    }

    setState(() {
      isLoading = true;
      error = null;
      results = [];
    });

    try {
      final input =
          "Noun: ${nounController.text.trim()}, "
          "Verb: ${verbController.text.trim()}, "
          "Tense: $tense, Gender: $gender";

      final res = await ApiService.sentence(input);

      if (!mounted) return;

      setState(() {
        results = res;
      });

    } catch (e) {
      setState(() {
        error = e.toString().contains("Session")
            ? "Session expired. Login again ❌"
            : "Something went wrong ❌";
      });
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  // 📋 COPY
  void copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied ✅")),
    );
  }

  // 🔹 RESULT BOX (UPDATED WITH SPEAKER)
  Widget resultBox(int index, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.shade300,
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

          // 🔊 SPEAKER BUTTON
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () => speak(text),
          ),

          // 📋 COPY
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () => copy(text),
          ),
        ],
      ),
    );
  }

  // 🔹 INPUT BOX
  Widget inputBox(
      String label,
      TextEditingController controller,
      IconData icon,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(label),

        const SizedBox(height: 6),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.red.shade300,
            borderRadius: BorderRadius.circular(18),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              icon: Icon(icon),
              border: InputBorder.none,
            ),
          ),
        ),

        const SizedBox(height: 12),
      ],
    );
  }

  // 🔹 DROPDOWN
  Widget dropdown(
      String label,
      String value,
      List<String> items,
      Function(String?) onChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(label),

        const SizedBox(height: 6),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.red.shade300,
            borderRadius: BorderRadius.circular(18),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: items.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Text(e.toUpperCase()),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),

        const SizedBox(height: 12),
      ],
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

                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),

                const Text(
                  "Sentence Builder",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                inputBox("Noun", nounController, Icons.person),
                inputBox("Verb", verbController, Icons.edit),

                dropdown(
                  "Tense",
                  tense,
                  ["past", "present", "future"],
                      (val) => setState(() => tense = val!),
                ),

                dropdown(
                  "Gender",
                  gender,
                  ["any", "male", "female"],
                      (val) => setState(() => gender = val!),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : generate,
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
                      "Generate Sentences ✨",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                const SizedBox(height: 20),

                const Text("Generated Sentences"),

                const SizedBox(height: 10),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: results.length,
                  itemBuilder: (_, i) =>
                      resultBox(i, results[i]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}