package com.musicschool.musicschoolbackend.repository;

import com.musicschool.musicschoolbackend.model.Availability;
import com.musicschool.musicschoolbackend.model.Professor;
import org.springframework.data.jpa.repository.JpaRepository;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

public interface AvailabilityRepository extends JpaRepository<Availability, Long> {
    List<Availability> findByProfessorAndAvailabilityDateAfterOrderByAvailabilityDateAscStartTimeAsc(Professor professor, LocalDate date);
    List<Availability> findByProfessorIdAndAvailabilityDateAndIsBookedFalse(Long professorId, LocalDate date);
    List<Availability> findByProfessorIdAndAvailabilityDateBetweenAndIsBookedFalse(Long professorId, LocalDate startDate, LocalDate endDate);
    Optional<Availability> findByIdAndIsBookedFalse(Long id); // Find unbooked availability by ID

    // To check for overlapping slots when adding a new availability
    boolean existsByProfessorIdAndAvailabilityDateAndStartTimeBeforeAndEndTimeAfter(
            Long professorId, LocalDate availabilityDate, LocalTime newEndTime, LocalTime newStartTime);

    Optional<Availability> findByProfessorIdAndAvailabilityDateAndStartTime(Long professorId, LocalDate date, LocalTime startTime);
}