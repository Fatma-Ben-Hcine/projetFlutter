package com.musicschool.musicschoolbackend.controller;

import com.musicschool.musicschoolbackend.dto.AvailabilityDTO;
import com.musicschool.musicschoolbackend.service.AvailabilityService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/availabilities")
public class AvailabilityController {

    private final AvailabilityService availabilityService;

    public AvailabilityController(AvailabilityService availabilityService) {
        this.availabilityService = availabilityService;
    }

    // Public endpoint to retrieve unbooked availabilities for a professor within a date range
    @GetMapping("/professor/{professorId}")
    public ResponseEntity<List<AvailabilityDTO>> getAvailableSlotsForProfessor(
            @PathVariable Long professorId,
            @RequestParam("startDate") LocalDate startDate,
            @RequestParam("endDate") LocalDate endDate) {
        List<AvailabilityDTO> availabilities = availabilityService.getAvailableSlotsForProfessor(professorId, startDate, endDate);
        return ResponseEntity.ok(availabilities);
    }

    // Endpoint to create an availability (only by the professor or an admin)
    @PostMapping("/professor/{professorId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'PROFESSOR') and @securityUtil.isProfessor(#professorId)")
    public ResponseEntity<AvailabilityDTO> createAvailability(
            @PathVariable Long professorId,
            @Valid @RequestBody AvailabilityDTO availabilityDTO) {
        AvailabilityDTO createdAvailability = availabilityService.createAvailability(professorId, availabilityDTO);
        return new ResponseEntity<>(createdAvailability, HttpStatus.CREATED);
    }

    // Endpoint to update an availability (only by the professor or an admin)
    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'PROFESSOR') and @securityUtil.isProfessor(@availabilityService.getProfessorIdFromAvailability(#id))")
    public ResponseEntity<AvailabilityDTO> updateAvailability(@PathVariable Long id, @Valid @RequestBody AvailabilityDTO availabilityDTO) {
        AvailabilityDTO updatedAvailability = availabilityService.updateAvailability(id, availabilityDTO);
        return ResponseEntity.ok(updatedAvailability);
    }

    // Endpoint to delete an availability (only by the professor or an admin)
    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'PROFESSOR') and @securityUtil.isProfessor(@availabilityService.getProfessorIdFromAvailability(#id))")
    public ResponseEntity<Void> deleteAvailability(@PathVariable Long id) {
        availabilityService.deleteAvailability(id);
        return ResponseEntity.noContent().build();
    }
}