package com.example.tamilai.dto;

import java.time.LocalDateTime;


public class HistoryResponseDTO {

    private Long id;
    private String type;
    private String inputText;
    private String outputText;
    private LocalDateTime createdAt;

    public HistoryResponseDTO(Long id, String type, String inputText,
                              String outputText, LocalDateTime createdAt) {
        this.id = id;
        this.type = type;
        this.inputText = inputText;
        this.outputText = outputText;
        this.createdAt = createdAt;
    }

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getInputText() {
		return inputText;
	}

	public void setInputText(String inputText) {
		this.inputText = inputText;
	}

	public String getOutputText() {
		return outputText;
	}

	public void setOutputText(String outputText) {
		this.outputText = outputText;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}
}