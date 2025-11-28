package com.musicschool.musicschoolbackend.dto;

import com.musicschool.musicschoolbackend.model.Role;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class RegisterRequest {
    @NotBlank(message = "L'e-mail ne peut pas être vide.")
    @Email(message = "Le format de l'e-mail est invalide.")
    private String email;
    @NotBlank(message = "Le mot de passe ne peut pas être vide.")
    @Size(min = 6, message = "Le mot de passe doit contenir au moins 6 caractères.")
    private String password;
    @NotBlank(message = "Le prénom ne peut pas être vide.")
    private String firstName;
    @NotBlank(message = "Le nom de famille ne peut pas être vide.")
    private String lastName;
    private Role role; // STUDENT, PROFESSOR, ADMIN
}