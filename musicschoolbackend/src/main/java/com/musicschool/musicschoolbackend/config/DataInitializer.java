package com.musicschool.musicschoolbackend.config;

import com.musicschool.musicschoolbackend.model.Instrument;
import com.musicschool.musicschoolbackend.model.Professor;
import com.musicschool.musicschoolbackend.model.Role;
import com.musicschool.musicschoolbackend.model.User;
import com.musicschool.musicschoolbackend.repository.InstrumentRepository;
import com.musicschool.musicschoolbackend.repository.ProfessorRepository;
import com.musicschool.musicschoolbackend.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional; // IMPORTANT: Ajouter cette annotation

import java.util.HashSet;
import java.util.Set;

@Component
public class DataInitializer implements CommandLineRunner {

    private final UserRepository userRepository;
    private final ProfessorRepository professorRepository;
    private final InstrumentRepository instrumentRepository;
    private final PasswordEncoder passwordEncoder;

    public DataInitializer(UserRepository userRepository, ProfessorRepository professorRepository, InstrumentRepository instrumentRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.professorRepository = professorRepository;
        this.instrumentRepository = instrumentRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    @Transactional // <--- Assurez-vous que toute l'opération est dans une transaction
    public void run(String... args) throws Exception {
        if (userRepository.count() == 0) { // Only if the database is empty
            // Create instruments
            Instrument piano = new Instrument(null, "Piano", "Instrument à clavier polyvalent.", "url_piano_icon");
            Instrument guitare = new Instrument(null, "Guitare", "Instrument à cordes pincées.", "url_guitare_icon");
            Instrument violon = new Instrument(null, "Violon", "Instrument à cordes frottées.", "url_violon_icon");
            Instrument batterie = new Instrument(null, "Batterie", "Ensemble de percussions.", "url_batterie_icon");

            instrumentRepository.save(piano);
            instrumentRepository.save(guitare);
            instrumentRepository.save(violon);
            instrumentRepository.save(batterie);

            // Create ADMIN
            User adminUser = new User();
            adminUser.setEmail("admin@musicschool.com");
            adminUser.setPassword(passwordEncoder.encode("adminpass"));
            adminUser.setFirstName("Super");
            adminUser.setLastName("Admin");
            adminUser.setRole(Role.ADMIN);
            adminUser.setProfileImageUrl("url_admin_profile");
            userRepository.save(adminUser);

            // Create a Professor User
            User profUser = new User();
            profUser.setEmail("prof@musicschool.com");
            profUser.setPassword(passwordEncoder.encode("profpass"));
            profUser.setFirstName("Jean");
            profUser.setLastName("Dupont");
            profUser.setRole(Role.PROFESSOR);
            profUser.setProfileImageUrl("url_jean_profile");
            // NOTE: Nous ne sauvons PAS profUser ici car nous allons le lier à Professor et laisser la cascade gérer.
            // Si profUser est sauvegardé ici, il aura un ID, mais si professorDetails est null,
            // la relation OneToOne ne sera pas initiée correctement, ce qui peut causer des problèmes avec @MapsId.

            // Create Professor details
            Professor professor = new Professor();
            professor.setBio("Professeur de musique passionné avec 10 ans d'expérience.");
            professor.setHourlyRate(60.0);
            professor.setAverageRating(4.5);
            Set<Instrument> profInstruments = new HashSet<>();
            profInstruments.add(piano);
            profInstruments.add(guitare);
            professor.setInstrumentsTaught(profInstruments);

            // Lier bidirectionnellement :
            profUser.setProfessorDetails(professor); // Définit professorDetails sur l'utilisateur
            professor.setUser(profUser);            // Définit l'utilisateur sur le professeur

            // Maintenant, sauvegardez l'utilisateur. Grâce à CascadeType.ALL et @MapsId/@PrimaryKeyJoinColumn,
            // le professeur devrait être sauvegardé automatiquement avec le bon ID.
            userRepository.save(profUser);


            // Create a Student
            User studentUser = new User();
            studentUser.setEmail("student@musicschool.com");
            studentUser.setPassword(passwordEncoder.encode("studentpass"));
            studentUser.setFirstName("Alice");
            studentUser.setLastName("Martin");
            studentUser.setRole(Role.STUDENT);
            studentUser.setProfileImageUrl("url_alice_profile");
            userRepository.save(studentUser);

            System.out.println("Données initiales chargées !");


        }
    }
}