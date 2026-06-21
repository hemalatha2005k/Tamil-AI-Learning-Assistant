import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'success_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  final newPass = TextEditingController();
  final confirmPass = TextEditingController();

  bool isLoading = false;
  bool showPassword = false;

  String? passError;
  String? confirmError;

  void validate() {
    setState(() {
      passError = newPass.text.length >= 6
          ? null
          : "Min 6 characters";

      confirmError = newPass.text == confirmPass.text
          ? null
          : "Passwords do not match";
    });
  }

  void reset() async {

    validate();

    if (passError != null || confirmError != null) return;

    setState(() => isLoading = true);

    try {

      // 🔍 DEBUG (optional)
      print("EMAIL: ${widget.email}");
      print("OTP: ${widget.otp}");

      await ApiService.resetPassword(
        widget.email,
        widget.otp,
        newPass.text.trim(),
        confirmPass.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const SuccessScreen(),
        ),
      );

    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()), // 🔥 REAL ERROR
        ),
      );
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  Widget input(
      TextEditingController c,
      String hint, {
        String? error,
      }) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: TextField(
            controller: c,
            obscureText: !showPassword,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(
                  showPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
              ),
            ),
          ),
        ),

        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(error,
                style: const TextStyle(color: Colors.red)),
          ),

        const SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFAFC0F7),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [

              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
              ),

              const SizedBox(height: 20),

              const Icon(Icons.lock, size: 60),

              const SizedBox(height: 10),

              const Text(
                "Reset Password",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                "Reset password for\n${widget.email}",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 25),

              input(newPass, "New Password", error: passError),
              input(confirmPass, "Confirm Password", error: confirmError),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : reset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B5BEF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Reset Password"),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}