import 'package:flutter/material.dart';

Widget inputField(
    TextEditingController controller,
    String hint,
    IconData icon, {
      bool isPassword = false,
      bool showPassword = false,
      VoidCallback? toggle,
    }) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.9),
      borderRadius: BorderRadius.circular(14),
    ),
    child: TextField(
      controller: controller,
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
          onPressed: toggle,
        )
            : null,
      ),
    ),
  );
}

Widget primaryButton(
    String text,
    VoidCallback onTap, {
      bool isLoading = false,
    }) {
  return GestureDetector(
    onTap: isLoading ? null : onTap,
    child: Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5B5BEF), Color(0xFF7A6CFF)],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}