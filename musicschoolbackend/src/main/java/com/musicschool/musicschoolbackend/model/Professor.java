package com.musicschool.musicschoolbackend.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "professors")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Professor {

    @Id
    private Long id; // Same as User ID for a 1:1 relationship

    @OneToOne(fetch = FetchType.LAZY)
    @MapsId // Use id of User as primary key
    @JoinColumn(name = "id")
    private User user; // Reference to the User entity

    @Column(columnDefinition = "TEXT")
    private String bio;

    private Double hourlyRate; // e.g., 60.0

    private Double averageRating; // Calculated, can be null initially

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "professor_instruments",
            joinColumns = @JoinColumn(name = "professor_id"),
            inverseJoinColumns = @JoinColumn(name = "instrument_id")
    )
    private Set<Instrument> instrumentsTaught = new HashSet<>();

    @OneToMany(mappedBy = "professor", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<Review> reviews = new HashSet<>(); // Reviews for this professor
}