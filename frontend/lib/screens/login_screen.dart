import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/storage.dart';
import 'home_screen.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final email = TextEditingController();
  final password = TextEditingController();

  bool isLoading = false;
  bool showPassword = false;

  String? emailError, passError;

  void validate() {
    setState(() {
      emailError = email.text.contains("@") ? null : "Enter valid email";
      passError = password.text.length >= 6 ? null : "Min 6 characters";
    });
  }

  void login() async {
    validate();
    if (emailError != null || passError != null) return;

    setState(() => isLoading = true);

    try {
      final tokens = await ApiService.login(
        email.text.trim(),
        password.text.trim(),
      );

      // ✅ SAVE TOKENS
      await StorageService.saveTokens(
        tokens["accessToken"]!,
        tokens["refreshToken"]!,
      );

      // 🔥 SAVE USER DATA (IMPORTANT FIX)
      await StorageService.saveUser(
        tokens["name"] ?? "User",
        tokens["email"] ?? "user@gmail.com",
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );

    } catch (e) {
      if (!mounted) return;
      showMsg("Invalid Email or Password ❌");
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget input(TextEditingController c, String hint, IconData icon,
      {bool isPassword = false, String? error}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(18),
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
                  showPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
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
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(error, style: const TextStyle(color: Colors.red)),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [

                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                const Icon(Icons.auto_awesome, size: 40),
                const SizedBox(height: 5),
                const Text("தமிழ் AI",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.blue, width: 2),
                  ),

                  child: Column(
                    children: [

                      input(email, "Enter Email", Icons.email,
                          error: emailError),

                      input(password, "Enter Password", Icons.lock,
                          isPassword: true, error: passError),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : login,
                          child: isLoading
                              ? const CircularProgressIndicator(
                              color: Colors.white)
                              : const Text("Login"),
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: const Text("Forget Password?"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: const Text("Register",
                      style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}