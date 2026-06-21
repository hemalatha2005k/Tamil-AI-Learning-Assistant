import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/bottom_nav.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  List data = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  // 🔥 LOAD HISTORY (FIXED)
  Future<void> loadHistory() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      // ✅ NO TOKEN
      final res = await ApiService.getHistory();

      if (!mounted) return;

      setState(() {
        data = res;
        isLoading = false;
      });

    } catch (e) {
      setState(() {
        error = "Session expired. Login again ❌";
        isLoading = false;
      });
    }
  }

  // ⭐ SAVE / UNSAVE (FIXED)
  Future toggleSave(Map item) async {
    final isSaved = item["saved"] ?? false;

    try {
      if (isSaved) {
        await ApiService.unSave(item["id"]);
      } else {
        await ApiService.save(item["id"]);
      }

      // 🔁 reload
      await loadHistory();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Action failed ❌")),
      );
    }
  }

  // 🎨 CARD UI
  Widget card(Map item) {
    final isSaved = item["saved"] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.shade300,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["inputText"] ?? "",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(item["outputText"] ?? ""),
              ],
            ),
          ),

          IconButton(
            icon: Icon(
              Icons.bookmark,
              color: isSaved ? Colors.blue : Colors.black,
            ),
            onPressed: () => toggleSave(item),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8ECFF),
      bottomNavigationBar: const BottomNav(currentIndex: 1),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                "History",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : error != null
                    ? Center(child: Text(error!))
                    : data.isEmpty
                    ? const Center(child: Text("No history found"))
                    : RefreshIndicator(
                  onRefresh: loadHistory,
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