package com.musicschool.musicschoolbackend.controller;

import com.musicschool.musicschoolbackend.dto.BookSessionRequest;
import com.musicschool.musicschoolbackend.dto.SessionDTO;
import com.musicschool.musicschoolbackend.service.SessionService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/sessions")
public class SessionController {

    private final SessionService sessionService;

    public SessionController(SessionService sessionService) {
        this.sessionService = sessionService;
    }

    // Endpoint to retrieve all sessions for a student (only the student or an admin)
    @GetMapping("/student/{studentId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'STUDENT') and @securityUtil.isStudent(#studentId)")
    public ResponseEntity<List<SessionDTO>> getStudentSessions(@PathVariable Long studentId) {
        List<SessionDTO> sessions = sessionService.getStudentSessions(studentId);
        return ResponseEntity.ok(sessions);
    }

    // Endpoint to retrieve all sessions for a professor (only the professor or an admin)
    @GetMapping("/professor/{professorId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'PROFESSOR') and @securityUtil.isProfessor(#professorId)")
    public ResponseEntity<List<SessionDTO>> getProfessorSessions(@PathVariable Long professorId) {
        List<SessionDTO> sessions = sessionService.getProfessorSessions(professorId);
        return ResponseEntity.ok(sessions);
    }

    // Endpoint to retrieve a session by ID (concerned student, professor or admin)
    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'STUDENT', 'PROFESSOR') and @securityUtil.isSessionParticipant(#id)")
    public ResponseEntity<SessionDTO> getSessionById(@PathVariable Long id) {
        SessionDTO session = sessionService.getSessionById(id);
        return ResponseEntity.ok(session);
    }

    // Endpoint to book a session (only by a student)
    @PostMapping("/book")
    @PreAuthorize("hasRole('STUDENT')") // Only students can book
    public ResponseEntity<SessionDTO> bookSession(@Valid @RequestBody BookSessionRequest request) {
        SessionDTO bookedSession = sessionService.bookSession(request);
        return new ResponseEntity<>(bookedSession, HttpStatus.CREATED);
    }

    // Endpoint to cancel a session (concerned student, professor or admin)
    @PutMapping("/{id}/cancel")
    @PreAuthorize("hasAnyRole('ADMIN', 'STUDENT', 'PROFESSOR') and @securityUtil.isSessionParticipant(#id)")
    public ResponseEntity<SessionDTO> cancelSession(@PathVariable Long id) {
        SessionDTO cancelledSession = sessionService.cancelSession(id);
        return ResponseEntity.ok(cancelledSession);
    }
}