import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends State<ChangePasswordScreen> {

  final oldController = TextEditingController();
  final newController = TextEditingController();
  final confirmController = TextEditingController();

  bool isLoading = false;
  String? error;

  static const Color primaryColor = Color(0xFF5B5BEF);

  // 🔐 CHANGE PASSWORD (FIXED)
  void changePassword() async {

    String oldPass = oldController.text.trim();
    String newPass = newController.text.trim();
    String confirmPass = confirmController.text.trim();

    // ✅ VALIDATION
    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      setState(() => error = "All fields required");
      return;
    }

    if (newPass.length < 6) {
      setState(() => error = "Password must be at least 6 characters");
      return;
    }

    if (newPass != confirmPass) {
      setState(() => error = "Passwords do not match");
      return;
    }

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      // 🔥 FIXED API CALL (NO TOKEN)
      await ApiService.changePassword(
        oldPass,
        newPass,
        confirmPass,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password updated ✅")),
      );

      Navigator.pop(context);

    } catch (e) {
      setState(() {
        error = e.toString().replaceAll("Exception:", "");
      });
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  // 🔹 INPUT FIELD
  Widget inputField(
      String hint,
      TextEditingController controller,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFE8ECFF),

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
                  "Change Password",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // 🔐 INPUTS
                inputField("Old Password", oldController),
                inputField("New Password", newController),
                inputField("Confirm Password", confirmController),

                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                const SizedBox(height: 10),

                // 🔘 BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding:
                      const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text(
                      "Update Password",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}