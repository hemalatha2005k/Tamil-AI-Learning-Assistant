import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  bool agree = false;
  bool isLoading = false;
  bool showPassword = false;

  String? nameError, emailError, passError, confirmError;

  // 🔥 VALIDATION
  void validate() {
    setState(() {
      nameError = name.text.isEmpty ? "Enter name" : null;

      emailError = email.text.contains("@")
          ? null
          : "Enter valid email";

      passError = password.text.length >= 6
          ? null
          : "Min 6 characters";

      confirmError = password.text == confirmPassword.text
          ? null
          : "Passwords not match";
    });
  }

  // 🔥 REGISTER
  void register() async {

    validate();

    if (nameError != null ||
        emailError != null ||
        passError != null ||
        confirmError != null ||
        !agree) {

      show("Fill all fields correctly");
      return;
    }

    setState(() => isLoading = true);

    try {
      await ApiService.register(
        name.text.trim(),
        email.text.trim(),
        password.text.trim(),
      );

      if (!mounted) return;

      show("Registered Successfully ✅");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );

    } catch (e) {
      if (!mounted) return;
      show("Register Failed ❌");
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  void show(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // 🔹 INPUT FIELD
  Widget input(
      TextEditingController c,
      String hint,
      IconData icon, {
        bool isPassword = false,
        String? error,
      }) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: TextField(
            controller: c,
            obscureText: isPassword ? !showPassword : false,
            decoration: InputDecoration(
              icon: Icon(icon),
              hintText: hint,
              border: InputBorder.none,
              suffixIcon: isPassword
                  ? IconButton(
                icon: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
              )
                  : null,
            ),
          ),
        ),

        if (error != null)
          Text(error, style: const TextStyle(color: Colors.red)),

        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFAFC0F7),

      body: SafeArea(
        child: SingleChildScrollView(   // ✅ FIXED OVERFLOW
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // 🔙 BACK
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),

                const SizedBox(height: 10),

                // 👤 ICON
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text("Join Tamil AI and Start Learning"),

                const SizedBox(height: 20),

                // 🔹 INPUTS
                input(name, "Full Name", Icons.person, error: nameError),
                input(email, "Email", Icons.email, error: emailError),
                input(password, "Password", Icons.lock,
                    isPassword: true, error: passError),
                input(confirmPassword, "Confirm Password", Icons.lock,
                    isPassword: true, error: confirmError),

                // ✅ TERMS
                Row(
                  children: [
                    Checkbox(
                      value: agree,
                      onChanged: (v) {
                        setState(() => agree = v!);
                      },
                    ),
                    const Expanded(
                      child: Text(
                        "I agree to Terms & Privacy Policy",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // 🔘 REGISTER BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B5BEF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Register"),
                  ),
                ),

                const SizedBox(height: 15),

                // 🔗 LOGIN
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20), // ✅ extra space for keyboard
              ],
            ),
          ),
        ),
      ),
    );
  }
}