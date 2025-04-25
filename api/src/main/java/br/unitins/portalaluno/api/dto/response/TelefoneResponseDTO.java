package br.unitins.portalaluno.api.dto.response;

import br.unitins.portalaluno.api.model.Telefone;

public record TelefoneResponseDTO(
    Long id,
    int ddd,
    String numero
) {
    public static TelefoneResponseDTO valueOf(Telefone tel){
        return new TelefoneResponseDTO(tel.getId(), tel.getDdd(), tel.getNumero());
    }
}
