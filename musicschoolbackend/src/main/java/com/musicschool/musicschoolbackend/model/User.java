package com.musicschool.musicschoolbackend.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String email;

    @Column(nullable = false)
    private String password; // Hashed password

    @Column(nullable = false)
    private String firstName;

    @Column(nullable = false)
    private String lastName;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role; // Student, Professor, Admin

    private String profileImageUrl; // URL to an image storage (e.g., AWS S3, Cloudinary)

    // @CreationTimestamp et @UpdateTimestamp sont généralement plus pratiques
    // que les @PrePersist/@PreUpdate manuels, assurez-vous que hibernate les supporte bien avec votre version.
    // Sinon, votre implémentation manuelle est correcte.
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Relationships - a user can be a professor
    @OneToOne(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY, orphanRemoval = true)
    @PrimaryKeyJoinColumn // <--- AJOUTEZ CETTE ANNOTATION ICI
    private Professor professorDetails;

    // @PrePersist et @PreUpdate peuvent être simplifiés ou retirés si vous utilisez @CreationTimestamp/@UpdateTimestamp sur les champs directement
    // Si vous gardez ces méthodes, il est préférable de ne pas utiliser @AllArgsConstructor, car il inclura ces champs dans le constructeur.
    // Ou alors, assurez-vous de les appeler dans votre constructeur AllArgsConstructor si vous l'utilisez manuellement.
    // Lombok @Data peut aussi interagir avec ces méthodes, parfois il est préférable de ne pas générer @AllArgsConstructor
    // ou de l'utiliser avec précaution en spécifiant les champs.
    // Pour l'instant, je vais juste me concentrer sur le mapping JPA.
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}