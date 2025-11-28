package com.musicschool.musicschoolbackend.controller;

import com.musicschool.musicschoolbackend.dto.ProfessorDTO;
import com.musicschool.musicschoolbackend.dto.ProfessorUpdateRequest;
import com.musicschool.musicschoolbackend.service.ProfessorService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/professors")
public class ProfessorController {

    private final ProfessorService professorService;

    public ProfessorController(ProfessorService professorService) {
        this.professorService = professorService;
    }

    // Public endpoint to retrieve all professors
    @GetMapping
    public ResponseEntity<List<ProfessorDTO>> getAllProfessors() {
        List<ProfessorDTO> professors = professorService.getAllProfessors();
        return ResponseEntity.ok(professors);
    }

    // Public endpoint to retrieve a professor by ID
    @GetMapping("/{id}")
    public ResponseEntity<ProfessorDTO> getProfessorById(@PathVariable Long id) {
        ProfessorDTO professor = professorService.getProfessorById(id);
        return ResponseEntity.ok(professor);
    }

    // Endpoint to update a professor's profile (only the professor himself or an admin)
    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'PROFESSOR') and @securityUtil.isProfessor(#id)")
    public ResponseEntity<ProfessorDTO> updateProfessorProfile(@PathVariable Long id, @Valid @RequestBody ProfessorUpdateRequest request) {
        ProfessorDTO updatedProfessor = professorService.updateProfessorProfile(id, request);
        return ResponseEntity.ok(updatedProfessor);
    }
}