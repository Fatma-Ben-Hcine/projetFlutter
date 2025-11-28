package com.musicschool.musicschoolbackend.repository;

import com.musicschool.musicschoolbackend.model.Professor;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ProfessorRepository extends JpaRepository<Professor, Long> {
    // Optional: find professors by instrument taught
    // @Query("SELECT p FROM Professor p JOIN p.instrumentsTaught i WHERE i.id = :instrumentId")
    // List<Professor> findByInstrumentsTaughtId(Long instrumentId);
}