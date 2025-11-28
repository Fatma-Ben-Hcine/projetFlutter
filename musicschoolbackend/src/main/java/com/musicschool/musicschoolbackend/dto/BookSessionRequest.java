package com.musicschool.musicschoolbackend.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookSessionRequest {
    @NotNull(message = "L'ID de la disponibilité est requis.")
    private Long availabilityId;
    @NotNull(message = "L'ID de l'instrument est requis.")
    private Long instrumentId;
}