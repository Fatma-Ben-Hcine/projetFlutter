package com.musicschool.musicschoolbackend.repository;

import com.musicschool.musicschoolbackend.model.Instrument;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface InstrumentRepository extends JpaRepository<Instrument, Long> {
    Optional<Instrument> findByName(String name);
    boolean existsByName(String name);
}