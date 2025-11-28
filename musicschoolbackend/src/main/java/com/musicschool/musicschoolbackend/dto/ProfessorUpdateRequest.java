package com.musicschool.musicschoolbackend.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProfessorUpdateRequest {
    @NotBlank(message = "La bio ne peut pas être vide.")
    private String bio;
    @DecimalMin(value = "0.0", inclusive = false, message = "Le tarif horaire doit être positif.")
    private Double hourlyRate;
    private String profileImageUrl;
    private List<Long> instrumentIds; // IDs of taught instruments
}