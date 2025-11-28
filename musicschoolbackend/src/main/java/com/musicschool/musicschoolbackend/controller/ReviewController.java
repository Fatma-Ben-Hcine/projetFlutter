package com.musicschool.musicschoolbackend.controller;

import com.musicschool.musicschoolbackend.dto.ReviewDTO;
import com.musicschool.musicschoolbackend.service.ReviewService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reviews")
public class ReviewController {

    private final ReviewService reviewService;

    public ReviewController(ReviewService reviewService) {
        this.reviewService = reviewService;
    }

    // Public endpoint to retrieve reviews for a professor
    @GetMapping("/professor/{professorId}")
    public ResponseEntity<List<ReviewDTO>> getReviewsForProfessor(@PathVariable Long professorId) {
        List<ReviewDTO> reviews = reviewService.getReviewsForProfessor(professorId);
        return ResponseEntity.ok(reviews);
    }

    // Endpoint to add a review for a professor (only by a student who has completed a session)
    @PostMapping("/professor/{professorId}")
    @PreAuthorize("hasRole('STUDENT')") // Only students can leave reviews
    public ResponseEntity<ReviewDTO> addReview(@PathVariable Long professorId, @Valid @RequestBody ReviewDTO reviewDTO) {
        ReviewDTO createdReview = reviewService.addReview(professorId, reviewDTO);
        return new ResponseEntity<>(createdReview, HttpStatus.CREATED);
    }

    // Admin could have endpoints to moderate/delete reviews
    // Example (not implemented in service for now):
    // @DeleteMapping("/{id}")
    // @PreAuthorize("hasRole('ADMIN')")
    // public ResponseEntity<Void> deleteReview(@PathVariable Long id) { ... }
}