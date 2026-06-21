package com.example.tamilai.service;

import java.util.Map;

import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class AIClientService {

    private final RestTemplate restTemplate;
    private final String AI_URL = "http://localhost:8000/ai";

    public AIClientService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    public Map<String, Object> callAI(String endpoint, String inputText) {

        try {
            String url = AI_URL + "/" + endpoint;

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            Map<String, String> body = Map.of(
                    "input_text", inputText
            );

            HttpEntity<Map<String, String>> request =
                    new HttpEntity<>(body, headers);

            ResponseEntity<Map> response = restTemplate.exchange(
                    url,
                    HttpMethod.POST,
                    request,
                    Map.class
            );

            Map<String, Object> resBody = response.getBody();

            if (resBody != null) {

                if (resBody.containsKey("result")) {
                    return Map.of("result", resBody.get("result"));
                }

                if (resBody.containsKey("versions")) {
                    return Map.of("result", resBody.get("versions"));
                }

                if (resBody.containsKey("sentences")) {
                    return Map.of("result", resBody.get("sentences"));
                }

                if (resBody.containsKey("error")) {
                    return Map.of("error", resBody.get("error"));
                }
            }

            return Map.of("error", "Invalid AI response");

        } catch (Exception e) {
            return Map.of("error", "AI service unavailable");
        }
    }
}