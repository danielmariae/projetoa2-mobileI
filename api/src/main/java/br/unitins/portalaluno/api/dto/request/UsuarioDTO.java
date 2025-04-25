package br.unitins.portalaluno.api.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record UsuarioDTO(
    @NotBlank(message = "Nome é obrigatório")
    String nome,

    @NotBlank(message = "Email é obrigatório")
    @Email(message = "Email inválido")
    String email,

    @NotBlank(message = "Senha é obrigatória")
    @Size(min = 8, message = "Senha deve ter no mínimo 8 caracteres")
    String senha,

    @NotBlank(message = "Pertença é obrigatória")
    String pertenca,

    @Valid
    EnderecoDTO endereco,
    
    @Valid
    TelefoneDTO telefone
){ }
