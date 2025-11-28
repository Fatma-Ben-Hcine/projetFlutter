package com.musicschool.musicschoolbackend.controller;

import com.musicschool.musicschoolbackend.dto.InstrumentDTO;
import com.musicschool.musicschoolbackend.service.InstrumentService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/instruments")
public class InstrumentController {

    private final InstrumentService instrumentService;

    public InstrumentController(InstrumentService instrumentService) {
        this.instrumentService = instrumentService;
    }

    // Public endpoint to get all instruments
    @GetMapping
    public ResponseEntity<List<InstrumentDTO>> getAllInstruments() {
        List<InstrumentDTO> instruments = instrumentService.getAllInstruments();
        return ResponseEntity.ok(instruments);
    }

    // Public endpoint to get an instrument by ID
    @GetMapping("/{id}")
    public ResponseEntity<InstrumentDTO> getInstrumentById(@PathVariable Long id) {
        InstrumentDTO instrument = instrumentService.getInstrumentById(id);
        return ResponseEntity.ok(instrument);
    }

    // Admin-only endpoint to create a new instrument
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<InstrumentDTO> createInstrument(@Valid @RequestBody InstrumentDTO instrumentDTO) {
        InstrumentDTO createdInstrument = instrumentService.createInstrument(instrumentDTO);
        return new ResponseEntity<>(createdInstrument, HttpStatus.CREATED);
    }

    // Admin-only endpoint to update an existing instrument
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<InstrumentDTO> updateInstrument(@PathVariable Long id, @Valid @RequestBody InstrumentDTO instrumentDTO) {
        InstrumentDTO updatedInstrument = instrumentService.updateInstrument(id, instrumentDTO);
        return ResponseEntity.ok(updatedInstrument);
    }

    // Admin-only endpoint to delete an instrument
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteInstrument(@PathVariable Long id) {
        instrumentService.deleteInstrument(id);
        return ResponseEntity.noContent().build();
    }
}