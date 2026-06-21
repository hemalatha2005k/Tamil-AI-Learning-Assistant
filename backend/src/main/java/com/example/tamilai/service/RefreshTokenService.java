package com.example.tamilai.service;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.tamilai.entity.RefreshToken;
import com.example.tamilai.repository.RefreshTokenRepository;

@Service
public class RefreshTokenService {

    @Autowired private RefreshTokenRepository repo;

    public void save(String token, String email) {

        RefreshToken rt = new RefreshToken();
        rt.setToken(token);
        rt.setEmail(email);
        rt.setExpiryDate(LocalDateTime.now().plusDays(1));

        repo.save(rt);
    }

    public String validate(String token) {

        RefreshToken rt = repo.findByToken(token)
                .orElseThrow(() -> new RuntimeException("Invalid refresh token"));

        if (rt.getExpiryDate().isBefore(LocalDateTime.now())) {
            throw new RuntimeException("Refresh token expired");
        }

        return rt.getEmail();
    }

    public void delete(String token) {
        repo.deleteByToken(token);
    }
}