package com.musicschool.musicschoolbackend.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class InstrumentDTO { // Used for responses and creation/update

    private Long id; // Id is null for creation, present for update/response

    @NotBlank(message = "Le nom de l'instrument ne peut pas être vide.")
    @Size(min = 2, max = 50, message = "Le nom de l'instrument doit contenir entre 2 et 50 caractères.")
    private String name;

    private String description;
    private String iconUrl; // Optional
}