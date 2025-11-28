package com.musicschool.musicschoolbackend.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ReviewDTO {
    private Long id;
    private Long professorId;
    private String professorName;
    private Long studentId;
    private String studentName;
    @NotNull(message = "La note est requise.")
    @Min(value = 1, message = "La note doit être au moins 1.")
    @Max(value = 5, message = "La note doit être au plus 5.")
    private Integer rating;
    @NotBlank(message = "Le commentaire ne peut pas être vide.")
    private String comment;
    private LocalDateTime createdAt;
}