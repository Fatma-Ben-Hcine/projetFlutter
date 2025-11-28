package com.musicschool.musicschoolbackend.service;

import com.musicschool.musicschoolbackend.dto.BookSessionRequest;
import com.musicschool.musicschoolbackend.dto.SessionDTO;
import com.musicschool.musicschoolbackend.model.*;
import com.musicschool.musicschoolbackend.repository.*;
import jakarta.persistence.EntityExistsException;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.YearMonth;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class SessionService {

    private final SessionRepository sessionRepository;
    private final AvailabilityRepository availabilityRepository;
    private final UserRepository userRepository;
    private final ProfessorRepository professorRepository;
    private final InstrumentRepository instrumentRepository;

    private static final int MAX_SESSIONS_PER_MONTH = 8; // Limit of 8 sessions per month

    public SessionService(SessionRepository sessionRepository, AvailabilityRepository availabilityRepository, UserRepository userRepository, ProfessorRepository professorRepository, InstrumentRepository instrumentRepository) {
        this.sessionRepository = sessionRepository;
        this.availabilityRepository = availabilityRepository;
        this.userRepository = userRepository;
        this.professorRepository = professorRepository;
        this.instrumentRepository = instrumentRepository;
    }

    private SessionDTO toDTO(Session session) {
        return new SessionDTO(
                session.getId(),
                session.getStudent().getId(),
                session.getStudent().getFirstName() + " " + session.getStudent().getLastName(),
                session.getProfessor().getId(),
                session.getProfessor().getUser().getFirstName() + " " + session.getProfessor().getUser().getLastName(),
                session.getInstrument().getId(),
                session.getInstrument().getName(),
                session.getSessionDateTime(),
                session.getStatus(),
                session.getBookedAt()
        );
    }

    @Transactional(readOnly = true)
    public List<SessionDTO> getStudentSessions(Long studentId) {
        return sessionRepository.findByStudentIdAndSessionDateTimeAfterOrderBySessionDateTimeAsc(studentId, LocalDateTime.now()).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<SessionDTO> getProfessorSessions(Long professorId) {
        return sessionRepository.findByProfessorIdAndSessionDateTimeAfterOrderBySessionDateTimeAsc(professorId, LocalDateTime.now()).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public SessionDTO getSessionById(Long sessionId) {
        Session session = sessionRepository.findById(sessionId)
                .orElseThrow(() -> new EntityNotFoundException("Session non trouvée avec l'ID: " + sessionId));
        return toDTO(session);
    }

    @Transactional
    public SessionDTO bookSession(BookSessionRequest request) {
        String authenticatedUserEmail = SecurityContextHolder.getContext().getAuthentication().getName();
        User student = userRepository.findByEmail(authenticatedUserEmail)
                .orElseThrow(() -> new EntityNotFoundException("Utilisateur élève non trouvé: " + authenticatedUserEmail));

        Availability availability = availabilityRepository.findByIdAndIsBookedFalse(request.getAvailabilityId())
                .orElseThrow(() -> new EntityNotFoundException("Créneau de disponibilité non trouvé ou déjà réservé avec l'ID: " + request.getAvailabilityId()));

        Instrument instrument = instrumentRepository.findById(request.getInstrumentId())
                .orElseThrow(() -> new EntityNotFoundException("Instrument non trouvé avec l'ID: " + request.getInstrumentId()));

        Professor professor = availability.getProfessor();

        // --- Business validation logic ---
        // 1. Check if the professor teaches this instrument
        if (!professor.getInstrumentsTaught().contains(instrument)) {
            throw new IllegalArgumentException("Le professeur n'enseigne pas cet instrument.");
        }

        // 2. Check the limit of 8 sessions per month for the student
        YearMonth currentMonth = YearMonth.from(availability.getAvailabilityDate());
        LocalDateTime startOfMonth = currentMonth.atDay(1).atStartOfDay();
        LocalDateTime endOfMonth = currentMonth.atEndOfMonth().atTime(23, 59, 59);

        long bookedSessionsThisMonth = sessionRepository.countByStudentAndSessionDateTimeBetweenAndStatus(
                student, startOfMonth, endOfMonth, SessionStatus.SCHEDULED);

        if (bookedSessionsThisMonth >= MAX_SESSIONS_PER_MONTH) {
            throw new IllegalStateException("L'élève a atteint la limite de " + MAX_SESSIONS_PER_MONTH + " sessions réservées ce mois-ci.");
        }

        // 3. Prevent double booking of the same slot
        if (availability.isBooked()) {
            throw new IllegalStateException("Ce créneau est déjà réservé.");
        }
        // --- End of validation logic ---

        // Create the session
        Session newSession = new Session();
        newSession.setStudent(student);
        newSession.setProfessor(professor);
        newSession.setInstrument(instrument);
        newSession.setSessionDateTime(LocalDateTime.of(availability.getAvailabilityDate(), availability.getStartTime()));
        newSession.setStatus(SessionStatus.SCHEDULED);

        Session savedSession = sessionRepository.save(newSession);

        // Mark availability as booked
        availability.setBooked(true);
        availability.setBookedByStudent(student);
        availabilityRepository.save(availability);

        return toDTO(savedSession);
    }

    @Transactional
    public SessionDTO cancelSession(Long sessionId) {
        String authenticatedUserEmail = SecurityContextHolder.getContext().getAuthentication().getName();
        User currentUser = userRepository.findByEmail(authenticatedUserEmail)
                .orElseThrow(() -> new EntityNotFoundException("Utilisateur non trouvé: " + authenticatedUserEmail));

        Session session = sessionRepository.findById(sessionId)
                .orElseThrow(() -> new EntityNotFoundException("Session non trouvée avec l'ID: " + sessionId));

        // Authorization: Only the booking student, professor, or an admin can cancel
        boolean isStudent = session.getStudent().getId().equals(currentUser.getId());
        boolean isProfessor = session.getProfessor().getId().equals(currentUser.getId());
        boolean isAdmin = currentUser.getRole().equals(Role.ADMIN);

        if (!(isStudent || isProfessor || isAdmin)) {
            throw new SecurityException("Vous n'êtes pas autorisé à annuler cette session.");
        }

        // Cancellation logic (can include time limit rules)
        if (session.getSessionDateTime().isBefore(LocalDateTime.now().plusHours(24))) { // Ex: Cancellation possible 24h before
            // throw new IllegalStateException("Les sessions ne peuvent être annulées moins de 24 heures à l'avance.");
            // For now, allow late cancellation for simplicity
        }

        if (session.getStatus() == SessionStatus.CANCELLED || session.getStatus() == SessionStatus.COMPLETED) {
            throw new IllegalStateException("La session est déjà annulée ou terminée.");
        }

        session.setStatus(SessionStatus.CANCELLED);
        Session updatedSession = sessionRepository.save(session);

        // Free up the availability slot
        availabilityRepository.findByProfessorIdAndAvailabilityDateAndStartTime(
                        session.getProfessor().getId(), session.getSessionDateTime().toLocalDate(), session.getSessionDateTime().toLocalTime())
                .ifPresent(availability -> {
                    availability.setBooked(false);
                    availability.setBookedByStudent(null);
                    availabilityRepository.save(availability);
                });


        return toDTO(updatedSession);
    }
}