package br.unitins.portalaluno.api.dto.request;

import jakarta.validation.constraints.NotBlank;

public record EnderecoDTO(
    @NotBlank(message = "Campo não pode ser nulo.")
    String cep,
    @NotBlank(message = "Campo não pode ser nulo.")
    String logradouro,
    @NotBlank(message = "Campo não pode ser nulo.")
    String numeroLote,
    @NotBlank(message = "Campo não pode ser nulo.")
    String bairro,
    @NotBlank(message = "Campo não pode ser nulo.")
    String complemento,
    @NotBlank(message = "Campo não pode ser nulo.")
    String localidade,
    @NotBlank(message = "Campo não pode ser nulo.")
    String UF   
) {
    
}
