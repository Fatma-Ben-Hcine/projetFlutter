package com.musicschool.musicschoolbackend.service;

import com.musicschool.musicschoolbackend.dto.InstrumentDTO;
import com.musicschool.musicschoolbackend.dto.ProfessorDTO;
import com.musicschool.musicschoolbackend.dto.ProfessorUpdateRequest;
import com.musicschool.musicschoolbackend.model.Instrument;
import com.musicschool.musicschoolbackend.model.Professor;
import com.musicschool.musicschoolbackend.repository.InstrumentRepository;
import com.musicschool.musicschoolbackend.repository.ProfessorRepository;
import com.musicschool.musicschoolbackend.repository.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class ProfessorService {

    private final ProfessorRepository professorRepository;
    private final UserRepository userRepository;
    private final InstrumentRepository instrumentRepository;

    public ProfessorService(ProfessorRepository professorRepository, UserRepository userRepository, InstrumentRepository instrumentRepository) {
        this.professorRepository = professorRepository;
        this.userRepository = userRepository;
        this.instrumentRepository = instrumentRepository;
    }

    private ProfessorDTO toDTO(Professor professor) {
        // Convertir la liste d'instruments en DTOs
        List<InstrumentDTO> instrumentDTOs = professor.getInstrumentsTaught().stream()
                .map(i -> new InstrumentDTO(i.getId(), i.getName(), i.getDescription(), i.getIconUrl()))
                .collect(Collectors.toList());

        return new ProfessorDTO(
                professor.getId(),
                professor.getUser().getEmail(),
                professor.getUser().getFirstName(),
                professor.getUser().getLastName(),
                professor.getBio(),
                professor.getHourlyRate(),
                professor.getAverageRating(),
                professor.getUser().getProfileImageUrl(),
                instrumentDTOs
        );
    }

    @Transactional(readOnly = true)
    public List<ProfessorDTO> getAllProfessors() {
        return professorRepository.findAll().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public ProfessorDTO getProfessorById(Long id) {
        Professor professor = professorRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Professeur non trouvé avec l'ID: " + id));
        return toDTO(professor);
    }

    @Transactional
    public ProfessorDTO updateProfessorProfile(Long id, ProfessorUpdateRequest request) {
        Professor professor = professorRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Professeur non trouvé avec l'ID: " + id));

        professor.setBio(request.getBio());
        professor.setHourlyRate(request.getHourlyRate());
        professor.getUser().setProfileImageUrl(request.getProfileImageUrl()); // Updates the URL in the User entity

        // Handle taught instruments
        if (request.getInstrumentIds() != null) {
            Set<Instrument> instruments = request.getInstrumentIds().stream()
                    .map(instrumentId -> instrumentRepository.findById(instrumentId)
                            .orElseThrow(() -> new EntityNotFoundException("Instrument non trouvé avec l'ID: " + instrumentId)))
                    .collect(Collectors.toSet());
            professor.setInstrumentsTaught(instruments);
        }

        Professor updatedProfessor = professorRepository.save(professor);
        userRepository.save(updatedProfessor.getUser()); // Save changes to User if necessary

        return toDTO(updatedProfessor);
    }

    // Method to update professor's average rating (called after adding a review)
    @Transactional
    public void updateProfessorAverageRating(Long professorId) {
        Professor professor = professorRepository.findById(professorId)
                .orElseThrow(() -> new EntityNotFoundException("Professeur non trouvé avec l'ID: " + professorId));

        Double averageRating = professor.getReviews().stream()
                .mapToInt(review -> review.getRating())
                .average()
                .orElse(0.0); // If no reviews, rating is 0.0

        professor.setAverageRating(averageRating);
        professorRepository.save(professor);
    }
}