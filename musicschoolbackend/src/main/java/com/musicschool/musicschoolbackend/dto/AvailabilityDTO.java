package com.musicschool.musicschoolbackend.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AvailabilityDTO {
    private Long id;
    private Long professorId;
    @NotNull(message = "La date de disponibilité est requise.")
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate availabilityDate;
    @NotNull(message = "L'heure de début est requise.")
    @JsonFormat(pattern = "HH:mm")
    private LocalTime startTime;
    @NotNull(message = "L'heure de fin est requise.")
    @JsonFormat(pattern = "HH:mm")
    private LocalTime endTime;
    private boolean isBooked;
    private Long bookedByStudentId; // Can be null
    private String bookedByStudentName; // Student's name if booked
}
