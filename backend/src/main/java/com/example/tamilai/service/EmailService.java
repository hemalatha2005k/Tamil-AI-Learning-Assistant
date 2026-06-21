package com.example.tamilai.service;

import jakarta.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    public void sendOtp(String email, String otp) {

        try {
            MimeMessage message = mailSender.createMimeMessage();

            MimeMessageHelper helper =
                    new MimeMessageHelper(message, true);

            // ✅ THIS IS THE FIX
            helper.setFrom("TamilAI <cskvetri2@gmail.com>");

            helper.setTo(email);
            helper.setSubject("OTP Verification");

            helper.setText(
                    "Hello,\n\n" +
                    "Your OTP for Tamil AI is: " + otp + "\n\n" +
                    "Valid for 5 minutes.\n" +
                    "Do not share with anyone.\n\n" +
                    "Thanks,\nTamil AI Team"
            );

            mailSender.send(message);

            System.out.println("Email sent successfully");

        } catch (Exception e) {
            System.out.println("Email failed: " + e.getMessage());
        }
    }
}