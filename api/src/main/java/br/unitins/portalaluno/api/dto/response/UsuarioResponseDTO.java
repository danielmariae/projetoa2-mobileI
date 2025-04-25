package br.unitins.portalaluno.api.dto.response;
import br.unitins.portalaluno.api.model.Usuario;

public record UsuarioResponseDTO(
    Long id,
    String nome,
    String email,
    String pertenca,
    EnderecoResponseDTO endereco,
    TelefoneResponseDTO telefone,
    String fotoPerfilUrl
) {
    // Método estático para converter de Entidade → Record
    public static UsuarioResponseDTO valueOf(Usuario usuario) {
        return new UsuarioResponseDTO(
            usuario.getId(),
            usuario.getNome(),
            usuario.getEmail(),
            usuario.getPertenca(),
            EnderecoResponseDTO.valueOf(usuario.getEndereco()),
            TelefoneResponseDTO.valueOf(usuario.getTelefone()),
            usuario.getFotoPerfilPath() != null 
                ? "http://localhost:8080/usuarios/download/imagem/"+usuario.getId() 
                : null
        );
    }
}
