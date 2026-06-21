package com.example.tamilai.dto;

import java.util.List; // ✅ correct import

public class AIResponseDTO {

    private String input;
    private String converted;
    private List<String> alternatives; // ✅ correct name

    public String getInput() {
        return input;
    }

    public void setInput(String input) {
        this.input = input;
    }

    public String getConverted() {
        return converted;
    }

    public void setConverted(String converted) {
        this.converted = converted;
    }

    public List<String> getAlternatives() { // ✅ correct getter
        return alternatives;
    }

    public void setAlternatives(List<String> alternatives) { // ✅ correct setter
        this.alternatives = alternatives;
    }
}