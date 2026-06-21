package com.example.tamilai.service;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.tamilai.dto.LoginRequest;
import com.example.tamilai.dto.RegisterRequest;
import com.example.tamilai.dto.ResetPasswordRequest;
import com.example.tamilai.entity.Otp;
import com.example.tamilai.entity.User;
import com.example.tamilai.repository.OtpRepository;
import com.example.tamilai.repository.UserRepository;
import com.example.tamilai.util.JwtUtil;

import jakarta.transaction.Transactional;

@Service
public class AuthService {

    @Autowired private UserRepository userRepo;
    @Autowired private OtpRepository otpRepo;
    @Autowired private PasswordEncoder encoder;
    @Autowired private JwtUtil jwtUtil;
    @Autowired private EmailService emailService;
    @Autowired private RefreshTokenService refreshService;

    // ✅ REGISTER
    public void register(RegisterRequest req) {

        if (userRepo.findByEmail(req.getEmail()).isPresent()) {
            throw new RuntimeException("Email already exists");
        }

        User user = new User();
        user.setName(req.getName());
        user.setEmail(req.getEmail());
        user.setPassword(encoder.encode(req.getPassword()));

        userRepo.save(user);
    }

    // ✅ LOGIN
    public Map<String, String> login(LoginRequest req) {

        User user = userRepo.findByEmail(req.getEmail())
                .orElseThrow(() -> new RuntimeException("Invalid credentials"));

        if (!encoder.matches(req.getPassword(), user.getPassword())) {
            throw new RuntimeException("Invalid credentials");
        }

        String accessToken = jwtUtil.generateAccessToken(user.getEmail());
        String refreshToken = jwtUtil.generateRefreshToken(user.getEmail());

        refreshService.save(refreshToken, user.getEmail());

        return Map.of(
            "accessToken", accessToken,
            "refreshToken", refreshToken,
            "name", user.getName(),    
            "email", user.getEmail()
        );
    }
    @Transactional
    // ✅ SEND OTP (RATE LIMITED)
    public void sendOtp(String email) {

        userRepo.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Otp lastOtp = otpRepo.findTopByEmailOrderByIdDesc(email).orElse(null);

        if (lastOtp != null &&
            lastOtp.getCreatedAt().plusSeconds(60).isAfter(LocalDateTime.now())) {

            throw new RuntimeException("Wait 1 minute before requesting OTP again");
        }

        otpRepo.deleteByEmail(email);

        String otp = String.valueOf(new SecureRandom().nextInt(900000) + 100000);

        Otp o = new Otp();
        o.setEmail(email);
        o.setOtp(otp);
        o.setCreatedAt(LocalDateTime.now());
        o.setExpiryTime(LocalDateTime.now().plusMinutes(5));

        otpRepo.save(o);

        emailService.sendOtp(email, otp);
    }
    @Transactional
    // ✅ RESET PASSWORD
    public void resetPassword(ResetPasswordRequest req) {

        User user = userRepo.findByEmail(req.getEmail())
                .orElseThrow(() -> new RuntimeException("User not found"));

        user.setPassword(encoder.encode(req.getNewPassword()));
        userRepo.save(user);

        // 🔥 delete OTP after success
        otpRepo.deleteByEmail(req.getEmail());
    }

    // ✅ REFRESH TOKEN
    public String refreshToken(String refreshToken) {
        String email = refreshService.validate(refreshToken);
        return jwtUtil.generateAccessToken(email);
    }
    @Transactional
    // ✅ LOGOUT
    public void logout(String refreshToken) {
        refreshService.delete(refreshToken);
    }
    public boolean verifyOtp(String email, String otp) {

        Otp savedOtp = otpRepo.findTopByEmailOrderByIdDesc(email)
                .orElseThrow(() -> new RuntimeException("OTP not found"));

        // ❌ WRONG OTP
        if (!savedOtp.getOtp().equals(otp)) {
            return false;
        }

        // ⏳ EXPIRED OTP
        if (savedOtp.getExpiryTime().isBefore(LocalDateTime.now())) {
            throw new RuntimeException("OTP expired");
        }

        return true;
    }
}