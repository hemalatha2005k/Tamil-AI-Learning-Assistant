package com.example.tamilai.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import com.example.tamilai.dto.ChangePasswordRequest;
import com.example.tamilai.dto.HistoryResponseDTO;
import com.example.tamilai.entity.User;
import com.example.tamilai.repository.HistoryRepository;
import com.example.tamilai.repository.UserRepository;
import com.example.tamilai.service.AIClientService;
import com.example.tamilai.service.HistoryService;
import com.example.tamilai.service.UserService;

@RestController
@RequestMapping("/api/ai")
@CrossOrigin
public class AIController {

    @Autowired private AIClientService aiService;
    @Autowired private HistoryService historyService;
    @Autowired private HistoryRepository historyRepository;
    @Autowired private UserRepository userRepository;
    @Autowired private UserService userService;

    private String getEmail() {
        var auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || auth.getName() == null) {
            throw new RuntimeException("Unauthorized");
        }
        return auth.getName();
    }

    @PostMapping("/translate")
    public Object translate(@RequestBody Map<String, String> req) {

        String input = req.get("input_text");

        Map<String, Object> result = aiService.callAI("translate", input);

        historyService.save(getEmail(), "translate", input, extract(result));

        return result;
    }

    @PostMapping("/rephrase")
    public Object rephrase(@RequestBody Map<String, String> req) {

        String input = req.get("input_text");

        Map<String, Object> result = aiService.callAI("rephrase", input);

        historyService.save(getEmail(), "rephrase", input, extract(result));

        return result;
    }

    @PostMapping("/sentence")
    public Object sentence(@RequestBody Map<String, String> req) {

        String input = req.get("input_text");

        Map<String, Object> result = aiService.callAI("sentence", input);

        historyService.save(getEmail(), "sentence", input, extract(result));

        return result;
    }

    @GetMapping("/history")
    public Object getHistory() {

        User user = userRepository.findByEmail(getEmail()).orElseThrow();

        return historyRepository.findByUserOrderByCreatedAtDesc(user)
                .stream()
                .map(h -> new HistoryResponseDTO(
                        h.getId(),
                        h.getType(),
                        h.getInputText(),
                        h.getOutputText(),
                        h.getCreatedAt()
                ))
                .toList();
    }

    @PostMapping("/save/{id}")
    public String save(@PathVariable Long id) {
        historyService.markAsSaved(id, getEmail());
        return "Saved successfully";
    }

    @PostMapping("/unsave/{id}")
    public String unsave(@PathVariable Long id) {
        historyService.unSave(id, getEmail());
        return "Removed from saved";
    }

    @GetMapping("/saved")
    public Object getSaved() {

        User user = userRepository.findByEmail(getEmail()).orElseThrow();

        return historyRepository
                .findByUserAndSavedTrueOrderByCreatedAtDesc(user)
                .stream()
                .map(h -> new HistoryResponseDTO(
                        h.getId(),
                        h.getType(),
                        h.getInputText(),
                        h.getOutputText(),
                        h.getCreatedAt()
                ))
                .toList();
    }

    @PostMapping("/change-password")
    public String changePassword(@RequestBody ChangePasswordRequest req) {
        return userService.changePassword(
                getEmail(),
                req.getOldPassword(),
                req.getNewPassword(),
                req.getConfirmPassword()
        );
    }

    private String extract(Map<String, Object> result) {

        if (result.containsKey("result")) {

            Object value = result.get("result");

            if (value instanceof List<?> list) {
                return String.join(", ",
                        list.stream().map(Object::toString).toList());
            }

            return value.toString();
        }

        if (result.containsKey("error")) {
            return "Error: " + result.get("error");
        }

        return "Unknown";
    }
}