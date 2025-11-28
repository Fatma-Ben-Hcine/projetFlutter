package com.musicschool.musicschoolbackend.service;

import com.musicschool.musicschoolbackend.dto.AuthRequest;
import com.musicschool.musicschoolbackend.dto.AuthResponse;
import com.musicschool.musicschoolbackend.dto.RegisterRequest;
import com.musicschool.musicschoolbackend.model.Professor;
import com.musicschool.musicschoolbackend.model.Role;
import com.musicschool.musicschoolbackend.model.User;
import com.musicschool.musicschoolbackend.repository.ProfessorRepository;
import com.musicschool.musicschoolbackend.repository.UserRepository;
import com.musicschool.musicschoolbackend.security.jwt.JwtUtil;
import com.musicschool.musicschoolbackend.security.service.UserDetailsServiceImpl;
import jakarta.persistence.EntityExistsException;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AuthService {

    private final UserRepository userRepository;
    private final ProfessorRepository professorRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;
    private final AuthenticationManager authenticationManager;
    private final UserDetailsServiceImpl userDetailsService;

    public AuthService(UserRepository userRepository, ProfessorRepository professorRepository, PasswordEncoder passwordEncoder, JwtUtil jwtUtil, AuthenticationManager authenticationManager, UserDetailsServiceImpl userDetailsService) {
        this.userRepository = userRepository;
        this.professorRepository = professorRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtUtil = jwtUtil;
        this.authenticationManager = authenticationManager;
        this.userDetailsService = userDetailsService;
    }

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new EntityExistsException("Un utilisateur avec cet e-mail existe déjà.");
        }

        User user = new User();
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setFirstName(request.getFirstName());
        user.setLastName(request.getLastName());
        user.setRole(request.getRole()); // Role will be set from the request

        User savedUser = userRepository.save(user);

        // if the user is a professor, create a professor entry
        if (request.getRole() == Role.PROFESSOR) {
            Professor professor = new Professor();
            professor.setId(savedUser.getId());
            professor.setUser(savedUser);
            // Default values for new professor
            professor.setBio("Enseignant de musique.");
            professor.setHourlyRate(50.0);
            professorRepository.save(professor);
            savedUser.setProfessorDetails(professor);
            userRepository.save(savedUser); // Update user to link professor details
        }

        UserDetails userDetails = userDetailsService.loadUserByUsername(savedUser.getEmail());
        String jwt = jwtUtil.generateToken(userDetails);

        return new AuthResponse(jwt, savedUser.getEmail(), savedUser.getRole().name(), savedUser.getId());
    }

    public AuthResponse authenticate(AuthRequest request) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword())
        );
        UserDetails userDetails = userDetailsService.loadUserByUsername(request.getEmail());
        if (userDetails != null) {
            String jwt = jwtUtil.generateToken(userDetails);
            User user = userRepository.findByEmail(request.getEmail())
                    .orElseThrow(() -> new EntityNotFoundException("Utilisateur non trouvé après authentification"));
            return new AuthResponse(jwt, user.getEmail(), user.getRole().name(), user.getId());
        }
        return null; // Should not happen if authentication is successful
    }
}