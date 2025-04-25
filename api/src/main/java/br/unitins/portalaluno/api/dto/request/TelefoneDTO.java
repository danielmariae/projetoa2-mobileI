package br.unitins.portalaluno.api.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record TelefoneDTO(
    @NotNull(message = "DDD não pode ser nulo.") int ddd,
    @NotBlank(message = "Número não pode estar em branco.") String numero
) {}
