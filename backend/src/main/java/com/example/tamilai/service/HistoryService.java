package com.example.tamilai.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.tamilai.entity.History;
import com.example.tamilai.entity.User;
import com.example.tamilai.repository.HistoryRepository;
import com.example.tamilai.repository.UserRepository;

@Service
public class HistoryService {

    @Autowired
    private HistoryRepository historyRepo;

    @Autowired
    private UserRepository userRepo;

    // ✅ AUTO SAVE (AI RESPONSE)
    public void save(String email, String type, String input, String output) {

        User user = userRepo.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));

        History history = new History();
        history.setUser(user);
        history.setType(type);
        history.setInputText(input);
        history.setOutputText(output);

        historyRepo.save(history);
    }

    // ⭐ SAVE FEATURE
    public void markAsSaved(Long id, String email) {

        User user = userRepo.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));

        History history = historyRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Not found"));

        if (!history.getUser().getId().equals(user.getId())) {
            throw new RuntimeException("Unauthorized");
        }

        // ✅ CORRECT FIX
        history.setSaved(true);

        historyRepo.save(history);
    }

    // ⭐ UNSAVE FEATURE
    public void unSave(Long id, String email) {

        User user = userRepo.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));

        History history = historyRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Not found"));

        if (!history.getUser().getId().equals(user.getId())) {
            throw new RuntimeException("Unauthorized");
        }

        // ✅ CORRECT FIX
        history.setSaved(false);

        historyRepo.save(history);
    }
}