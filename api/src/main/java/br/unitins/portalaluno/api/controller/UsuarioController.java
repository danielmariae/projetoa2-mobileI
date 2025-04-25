package br.unitins.portalaluno.api.controller;

import java.io.File;
import java.io.IOException;

import org.jboss.resteasy.reactive.multipart.FileUpload;

import br.unitins.portalaluno.api.dto.request.UsuarioDTO;
import br.unitins.portalaluno.api.dto.response.UsuarioResponseDTO;
import br.unitins.portalaluno.api.service.UsuarioService;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.DELETE;
import jakarta.ws.rs.FormParam;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.PATCH;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.PUT;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

@Path("/usuarios")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class UsuarioController {
    @Inject
    UsuarioService service;

    @POST
    public Response criarUsuario(@Valid UsuarioDTO usuarioDTO) {
        UsuarioResponseDTO response = service.create(usuarioDTO);
        return Response.status(201).entity(response).build();
    }

    @PUT
    @Path("/{id}")
    public Response atualizarUsuario(
        @PathParam("id") Long id,
        @Valid UsuarioDTO usuarioDTO
    ) {
        UsuarioResponseDTO response = service.update(id, usuarioDTO);
        return Response.ok(response).build();
    }

    @DELETE
    @Path("/{id}")
    public Response deletarUsuario(@PathParam("id") Long id) {
        service.delete(id);
        return Response.noContent().build();
    }
    
    @PATCH
    @Path("/upload/imagem/{id}")
    @Consumes(MediaType.MULTIPART_FORM_DATA)
    public Response salvarImagem(
        @FormParam("imagem") FileUpload imagem,
        @PathParam("id") Long id
    ) {
        try {
            String caminhoImagem = service.salvarImagem(id, imagem);
            return Response.ok(caminhoImagem).build();
        } catch (IOException e) {
            return Response.status(409).build();
        }
    }

    @GET
    @Path("/{id}")
    public Response getUsuarioById(@PathParam("id") Long id){
        UsuarioResponseDTO response = service.getUsuarioById(id);
        return Response.ok(response).build();
    }

    @GET
    @Path("/download/imagem/{id}")
    @Produces(MediaType.APPLICATION_OCTET_STREAM)
    public Response downloadImagemUsuario(@PathParam("id") Long id) {
        File imagem = service.obterArquivoImagem(id);
        
        if (imagem == null || !imagem.exists()) {
            return Response.status(Response.Status.NOT_FOUND)
                    .build();
        }

        return Response.ok(imagem)
                .header("Content-Disposition", "attachment; filename=\"" + imagem.getName() + "\"")
                .build();
    }
}
