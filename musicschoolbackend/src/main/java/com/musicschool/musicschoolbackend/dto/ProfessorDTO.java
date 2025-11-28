package com.musicschool.musicschoolbackend.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProfessorDTO {
    private Long id;
    private String email;
    private String firstName;
    private String lastName;
    private String bio;
    private Double hourlyRate;
    private Double averageRating;
    private String profileImageUrl;
    private List<InstrumentDTO> instrumentsTaught; // Uses the already created InstrumentDTO
}