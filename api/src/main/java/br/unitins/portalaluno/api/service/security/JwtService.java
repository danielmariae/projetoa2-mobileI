package br.unitins.portalaluno.api.service.security;

import java.time.Duration;
import java.time.Instant;
import java.util.HashSet;
import java.util.Set;

import br.unitins.portalaluno.api.dto.response.UsuarioResponseDTO;
import io.smallrye.jwt.build.Jwt;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class JwtService {
    private static final Duration EXPIRATION_TIME = Duration.ofHours(24);

    public String generateJwt(UsuarioResponseDTO dto){
        Instant now = Instant.now();
            Instant expiryDate = now.plus(EXPIRATION_TIME);
    
            Set<String> roles = new HashSet<String>();
            roles.add("User");
    
            return Jwt.issuer("handmaxx-jwt")
            .subject(dto.email())
            .groups(roles)
            .expiresAt(expiryDate)
            .sign();
        }    
}

