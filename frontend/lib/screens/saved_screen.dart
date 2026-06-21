import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../services/api_service.dart';
import '../widgets/bottom_nav.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {

  List data = [];
  bool isLoading = true;
  String? error;

  final FlutterTts tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    initTTS();
    loadSaved();
  }

  // 🔊 INIT TTS
  Future initTTS() async {
    await tts.setLanguage("ta-IN");
    await tts.setVolume(1.0);
    await tts.setSpeechRate(0.5);
    await tts.setPitch(1.0);
  }

  // 🔥 LOAD SAVED (FIXED)
  Future<void> loadSaved() async {
    setState(() => isLoading = true);

    try {
      final res = await ApiService.getSaved();

      if (!mounted) return;

      setState(() {
        data = res;
        isLoading = false;
      });

    } catch (e) {
      setState(() {
        error = "Failed to load ❌";
        isLoading = false;
      });
    }
  }

  // 🔊 SPEAK
  Future speak(String text) async {
    await tts.stop();
    await tts.speak(text);
  }

  // 📋 COPY
  void copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied ✅")),
    );
  }

  // ⭐ UNSAVE (FIXED)
  Future unSave(Map item) async {
    try {
      await ApiService.unSave(item["id"]);

      await loadSaved();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Removed from saved ✅")),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed ❌")),
      );
    }
  }

  // 🎨 CARD
  Widget card(Map item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.shade300,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            item["inputText"] ?? "",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Text(item["outputText"] ?? ""),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () => copy(item["outputText"] ?? ""),
              ),

              IconButton(
                icon: const Icon(Icons.volume_up),
                onPressed: () => speak(item["outputText"] ?? ""),
              ),

              IconButton(
                icon: const Icon(Icons.bookmark, color: Colors.blue),
                onPressed: () => unSave(item),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8ECFF),
      bottomNavigationBar: const BottomNav(currentIndex: 2),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                "Saved Items",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : error != null
                    ? Center(child: Text(error!))
                    : data.isEmpty
                    ? const Center(child: Text("No saved items"))
                    : RefreshIndicator(
                  onRefresh: loadSaved,
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (_, i) => card(data[i]),
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