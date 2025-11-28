package com.musicschool.musicschoolbackend.repository;

import com.musicschool.musicschoolbackend.model.Professor;
import com.musicschool.musicschoolbackend.model.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ReviewRepository extends JpaRepository<Review, Long> {
    List<Review> findByProfessorId(Long professorId);
    boolean existsByStudentIdAndProfessorIdAndSessionId(Long studentId, Long professorId, Long sessionId); // If a review is linked to a session
    boolean existsByStudentIdAndProfessorId(Long studentId, Long professorId); // Simplified: one review per student per professor
}