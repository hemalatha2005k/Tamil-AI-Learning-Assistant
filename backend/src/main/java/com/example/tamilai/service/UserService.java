package com.example.tamilai.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.tamilai.entity.User;
import com.example.tamilai.repository.UserRepository;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepo;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public String changePassword(String email, String oldPass, String newPass, String confirmPass) {

        User user = userRepo.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // ✅ check old password
        if (!passwordEncoder.matches(oldPass, user.getPassword())) {
            throw new RuntimeException("Old password is incorrect");
        }

        // ✅ check new == confirm
        if (!newPass.equals(confirmPass)) {
            throw new RuntimeException("Passwords do not match");
        }

        // ✅ update password
        user.setPassword(passwordEncoder.encode(newPass));
        userRepo.save(user);

        return "Password updated successfully";
    }
}