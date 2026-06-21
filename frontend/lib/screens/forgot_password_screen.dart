import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'otp_screen.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final email = TextEditingController();

  bool isLoading = false;
  String? emailError;

  // 🔥 VALIDATION
  void validate() {
    setState(() {
      emailError = email.text.contains("@")
          ? null
          : "Enter valid email";
    });
  }

  // 🔥 SEND OTP
  void sendOtp() async {

    validate();

    if (emailError != null) return;

    setState(() => isLoading = true);

    try {
      await ApiService.sendOtp(email.text.trim());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP Sent ✅")),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpScreen(email: email.text.trim()),
        ),
      );

    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to send OTP ❌")),
      );
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  // 🔹 INPUT FIELD
  Widget input() {
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
            controller: email,
            decoration: const InputDecoration(
              icon: Icon(Icons.email),
              hintText: "Enter email",
              border: InputBorder.none,
            ),
          ),
        ),

        if (emailError != null)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              emailError!,
              style: const TextStyle(color: Colors.red),
            ),
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

              // 🔙 BACK BUTTON
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
              ),

              const SizedBox(height: 10),

              // 🔒 LOCK ICON
              Container(
                height: 70,
                width: 70,
                decoration: const BoxDecoration(
                  color: Color(0xFF5B5BEF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock,
                  color: Colors.white,
                  size: 35,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                "Forget Password?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Don’t worry! Enter your email and we’ll send you a code.",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // 📩 EMAIL INPUT
              input(),

              const SizedBox(height: 10),

              // 🖼️ IMAGE (CENTER LIKE FIGMA)
              Expanded(
                child: Center(
                  child: Image.asset(
                    "assets/images/security.png",
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // 🔘 BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : sendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B5BEF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Send OTP"),
                ),
              ),

              const SizedBox(height: 15),

              // 🔙 BACK TO LOGIN
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text(
                  "Back to Login",
                  style: TextStyle(color: Colors.blue),
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