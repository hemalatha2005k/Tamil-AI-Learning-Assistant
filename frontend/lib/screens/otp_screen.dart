import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'reset_password_screen.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  final List<TextEditingController> otp =
  List.generate(6, (_) => TextEditingController());

  final List<FocusNode> focusNodes =
  List.generate(6, (_) => FocusNode());

  bool isLoading = false;

  // 🔥 VERIFY OTP (REAL)
  Future verifyOtp() async {

    String code = otp.map((e) => e.text).join();

    if (code.length != 6) {
      show("Enter full OTP");
      return;
    }

    setState(() => isLoading = true);

    try {
      await ApiService.verifyOtp(widget.email, code);

      if (!mounted) return;

      // ✅ SUCCESS → GO TO RESET
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(
            email: widget.email,
            otp: code,
          ),
        ),
      );

    } catch (e) {
      show("Invalid OTP ❌"); // 🔥 ERROR
    }

    setState(() => isLoading = false);
  }

  // 🔁 RESEND OTP
  Future resendOtp() async {
    try {
      await ApiService.resendOtp(widget.email);
      show("OTP sent again ✅");
    } catch (e) {
      show("Failed to resend ❌");
    }
  }

  void show(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // 🔹 OTP BOX
  Widget otpBox(int i) {
    return SizedBox(
      width: 45,
      child: TextField(
        controller: otp[i],
        focusNode: focusNodes[i],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,

        onChanged: (val) {
          if (val.isNotEmpty && i < 5) {
            FocusScope.of(context).requestFocus(focusNodes[i + 1]);
          }
          if (val.isEmpty && i > 0) {
            FocusScope.of(context).requestFocus(focusNodes[i - 1]);
          }
        },

        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var c in otp) c.dispose();
    for (var f in focusNodes) f.dispose();
    super.dispose();
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

              // 🔙 BACK
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
                "Verify OTP",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                "We sent OTP to\n${widget.email}",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              // 🔢 OTP BOXES
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (i) => otpBox(i)),
              ),

              const SizedBox(height: 25),

              // 🔁 RESEND
              TextButton(
                onPressed: resendOtp,
                child: const Text("Resend OTP"),
              ),

              const Spacer(),

              // 🔘 VERIFY BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B5BEF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Verify OTP"),
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