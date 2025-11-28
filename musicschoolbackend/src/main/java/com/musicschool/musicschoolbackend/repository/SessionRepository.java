package com.musicschool.musicschoolbackend.repository;

import com.musicschool.musicschoolbackend.model.Session;
import com.musicschool.musicschoolbackend.model.SessionStatus;
import com.musicschool.musicschoolbackend.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.List;

public interface SessionRepository extends JpaRepository<Session, Long> {
    List<Session> findByStudentIdAndSessionDateTimeAfterOrderBySessionDateTimeAsc(Long studentId, LocalDateTime dateTime);
    List<Session> findByProfessorIdAndSessionDateTimeAfterOrderBySessionDateTimeAsc(Long professorId, LocalDateTime dateTime);
    List<Session> findByStudentId(Long studentId);
    List<Session> findByProfessorId(Long professorId);

    // For the limit of 8 sessions per month
    long countByStudentAndSessionDateTimeBetweenAndStatus(User student, LocalDateTime startOfMonth, LocalDateTime endOfMonth, SessionStatus status);
}