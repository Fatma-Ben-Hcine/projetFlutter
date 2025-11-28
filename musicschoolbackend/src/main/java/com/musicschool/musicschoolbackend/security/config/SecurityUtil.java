package com.musicschool.musicschoolbackend.security.config;

import com.musicschool.musicschoolbackend.model.Role;
import com.musicschool.musicschoolbackend.model.User;
import com.musicschool.musicschoolbackend.repository.ProfessorRepository;
import com.musicschool.musicschoolbackend.repository.SessionRepository;
import com.musicschool.musicschoolbackend.repository.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component("securityUtil") // Bean name to be used in @PreAuthorize
public class SecurityUtil {

    private final UserRepository userRepository;
    private final ProfessorRepository professorRepository; // Add ProfessorRepository
    private final SessionRepository sessionRepository; // Add SessionRepository

    public SecurityUtil(UserRepository userRepository, ProfessorRepository professorRepository, SessionRepository sessionRepository) {
        this.userRepository = userRepository;
        this.professorRepository = professorRepository;
        this.sessionRepository = sessionRepository;
    }

    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return null;
        }
        String userEmail = authentication.getName();
        return userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new EntityNotFoundException("Utilisateur authentifié non trouvé : " + userEmail));
    }

    public boolean isProfessor(Long professorId) {
        User currentUser = getCurrentUser();
        if (currentUser == null) return false;

        return currentUser.getRole().equals(Role.ADMIN) ||
                (currentUser.getRole().equals(Role.PROFESSOR) && currentUser.getId().equals(professorId));
    }

    public boolean isStudent(Long studentId) {
        User currentUser = getCurrentUser();
        if (currentUser == null) return false;

        return currentUser.getRole().equals(Role.ADMIN) ||
                (currentUser.getRole().equals(Role.STUDENT) && currentUser.getId().equals(studentId));
    }

    public boolean isSessionParticipant(Long sessionId) {
        User currentUser = getCurrentUser();
        if (currentUser == null) return false;

        if (currentUser.getRole().equals(Role.ADMIN)) {
            return true; // Admin has access to all sessions
        }

        return sessionRepository.findById(sessionId)
                .map(session -> (currentUser.getId().equals(session.getStudent().getId()) && currentUser.getRole().equals(Role.STUDENT)) ||
                        (currentUser.getId().equals(session.getProfessor().getId()) && currentUser.getRole().equals(Role.PROFESSOR)))
                .orElse(false);
    }
}