package com.musicschool.musicschoolbackend.service;

import com.musicschool.musicschoolbackend.dto.ReviewDTO;
import com.musicschool.musicschoolbackend.model.Professor;
import com.musicschool.musicschoolbackend.model.Review;
import com.musicschool.musicschoolbackend.model.SessionStatus;
import com.musicschool.musicschoolbackend.model.User;
import com.musicschool.musicschoolbackend.repository.ProfessorRepository;
import com.musicschool.musicschoolbackend.repository.ReviewRepository;
import com.musicschool.musicschoolbackend.repository.SessionRepository;
import com.musicschool.musicschoolbackend.repository.UserRepository;
import jakarta.persistence.EntityExistsException;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ReviewService {

    private final ReviewRepository reviewRepository;
    private final ProfessorRepository professorRepository;
    private final UserRepository userRepository;
    private final SessionRepository sessionRepository;
    private final ProfessorService professorService; // To update professor's average rating

    public ReviewService(ReviewRepository reviewRepository, ProfessorRepository professorRepository, UserRepository userRepository, SessionRepository sessionRepository, ProfessorService professorService) {
        this.reviewRepository = reviewRepository;
        this.professorRepository = professorRepository;
        this.userRepository = userRepository;
        this.sessionRepository = sessionRepository;
        this.professorService = professorService;
    }

    private ReviewDTO toDTO(Review review) {
        return new ReviewDTO(
                review.getId(),
                review.getProfessor().getId(),
                review.getProfessor().getUser().getFirstName() + " " + review.getProfessor().getUser().getLastName(),
                review.getStudent().getId(),
                review.getStudent().getFirstName() + " " + review.getStudent().getLastName(),
                review.getRating(),
                review.getComment(),
                review.getCreatedAt()
        );
    }

    @Transactional(readOnly = true)
    public List<ReviewDTO> getReviewsForProfessor(Long professorId) {
        professorRepository.findById(professorId)
                .orElseThrow(() -> new EntityNotFoundException("Professeur non trouvé avec l'ID: " + professorId));
        return reviewRepository.findByProfessorId(professorId).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public ReviewDTO addReview(Long professorId, ReviewDTO reviewDTO) {
        String authenticatedUserEmail = SecurityContextHolder.getContext().getAuthentication().getName();
        User student = userRepository.findByEmail(authenticatedUserEmail)
                .orElseThrow(() -> new EntityNotFoundException("Utilisateur élève non trouvé: " + authenticatedUserEmail));

        Professor professor = professorRepository.findById(professorId)
                .orElseThrow(() -> new EntityNotFoundException("Professeur non trouvé avec l'ID: " + professorId));

        // Verification that the student had a COMPLETED session with this professor
        boolean hasCompletedSession = sessionRepository.findByStudentId(student.getId()).stream()
                .filter(s -> s.getProfessor().getId().equals(professorId) && s.getStatus() == SessionStatus.COMPLETED)
                .findFirst()
                .isPresent();

        if (!hasCompletedSession) {
            throw new IllegalStateException("L'élève doit avoir au moins une session terminée avec ce professeur pour laisser un avis.");
        }

        // Prevent the student from leaving multiple reviews for the same professor (if not linked to specific session)
        if (reviewRepository.existsByStudentIdAndProfessorId(student.getId(), professorId)) {
            throw new EntityExistsException("Vous avez déjà laissé un avis pour ce professeur.");
        }


        Review review = new Review();
        review.setProfessor(professor);
        review.setStudent(student);
        review.setRating(reviewDTO.getRating());
        review.setComment(reviewDTO.getComment());

        Review savedReview = reviewRepository.save(review);

        // Update professor's average rating
        professorService.updateProfessorAverageRating(professorId);

        return toDTO(savedReview);
    }

    // No update or delete methods for reviews by standard users for simplicity
    // These actions would be reserved for ADMIN
}