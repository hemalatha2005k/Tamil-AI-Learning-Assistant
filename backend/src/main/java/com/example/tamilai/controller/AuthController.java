package com.example.tamilai.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.example.tamilai.dto.*;
import com.example.tamilai.service.AuthService;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin
public class AuthController {

    @Autowired
    private AuthService authService;

    // ===============================
    // 🔐 REGISTER
    // ===============================
    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody RegisterRequest req) {
        authService.register(req);
        return ResponseEntity.ok(
                Map.of("message", "Registered successfully")
        );
    }

    // ===============================
    // 🔐 LOGIN
    // ===============================
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest req) {
        try {
            // returns access + refresh token
            return ResponseEntity.ok(authService.login(req));

        } catch (Exception e) {
            return ResponseEntity.status(401).body(
                    Map.of("message", "Invalid credentials")
            );
        }
    }

    // ===============================
    // 📩 SEND OTP (FIXED)
    // ===============================
    @PostMapping("/send-otp")
    public ResponseEntity<?> sendOtp(@RequestBody Map<String, String> req) {
        try {
            String email = req.get("email");

            if (email == null || email.isEmpty()) {
                return ResponseEntity.badRequest()
                        .body(Map.of("message", "Email is required"));
            }

            authService.sendOtp(email);

            return ResponseEntity.ok(
                    Map.of("message", "OTP sent successfully")
            );

        } catch (Exception e) {
            e.printStackTrace();

            return ResponseEntity.status(500).body(
                    Map.of(
                            "message", "Something went wrong",
                            "error", e.getMessage()
                    )
            );
        }
    }

    // ===============================
    // 🔄 RESET PASSWORD
    // ===============================
    @PostMapping("/reset-password")
    public ResponseEntity<?> resetPassword(@RequestBody ResetPasswordRequest req) {
        try {
            authService.resetPassword(req);

            return ResponseEntity.ok(
                    Map.of("message", "Password reset successful")
            );

        } catch (Exception e) {
            return ResponseEntity.status(400).body(
                    Map.of(
                            "message", "Reset failed",
                            "error", e.getMessage()
                    )
            );
        }
    }

    // ===============================
    // 🔁 REFRESH TOKEN
    // ===============================
    @PostMapping("/refresh")
    public ResponseEntity<?> refresh(@RequestBody Map<String, String> req) {

        String refreshToken = req.get("refreshToken");

        if (refreshToken == null || refreshToken.isEmpty()) {
            return ResponseEntity.badRequest()
                    .body(Map.of("message", "Refresh token required"));
        }

        try {
            String newAccessToken = authService.refreshToken(refreshToken);

            return ResponseEntity.ok(
                    Map.of("accessToken", newAccessToken)
            );

        } catch (Exception e) {
            return ResponseEntity.status(401).body(
                    Map.of(
                            "message", "Invalid refresh token",
                            "error", e.getMessage()
                    )
            );
        }
    }

    // ===============================
    // 🚪 LOGOUT
    // ===============================
    @PostMapping("/logout")
    public ResponseEntity<?> logout(@RequestBody Map<String, String> req) {

        String refreshToken = req.get("refreshToken");

        if (refreshToken == null || refreshToken.isEmpty()) {
            return ResponseEntity.badRequest()
                    .body(Map.of("message", "Refresh token required"));
        }

        authService.logout(refreshToken);

        return ResponseEntity.ok(
                Map.of("message", "Logged out successfully")
        );
    }
    @PostMapping("/verify-otp")
    public ResponseEntity<?> verifyOtp(@RequestBody Map<String, String> req) {
        try {
            String email = req.get("email");
            String otp = req.get("otp");

            if (email == null || otp == null || otp.isEmpty()) {
                return ResponseEntity.badRequest()
                        .body(Map.of("message", "Email and OTP required"));
            }

            boolean isValid = authService.verifyOtp(email, otp);

            if (!isValid) {
                return ResponseEntity.badRequest()
                        .body(Map.of("message", "Invalid OTP"));
            }

            return ResponseEntity.ok(
                    Map.of("message", "OTP verified successfully")
            );

        } catch (Exception e) {
            return ResponseEntity.status(500).body(
                    Map.of("message", e.getMessage())
            );
        }
    }
}