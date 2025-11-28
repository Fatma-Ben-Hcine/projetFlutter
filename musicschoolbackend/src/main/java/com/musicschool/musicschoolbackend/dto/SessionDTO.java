package com.musicschool.musicschoolbackend.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.musicschool.musicschoolbackend.model.SessionStatus;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SessionDTO {
    private Long id;
    private Long studentId;
    private String studentName;
    private Long professorId;
    private String professorName;
    private Long instrumentId;
    private String instrumentName;
    @NotNull(message = "La date et l'heure de la session sont requises.")
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private LocalDateTime sessionDateTime;
    private SessionStatus status;
    private LocalDateTime bookedAt;
}