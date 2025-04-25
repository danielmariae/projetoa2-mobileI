package br.unitins.portalaluno.api.model;

import jakarta.persistence.Entity;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Entity
@Data
@EqualsAndHashCode(callSuper = true)
public class Endereco extends DefaultEntity {
    private String cep;
    private String logradouro;
    private String numeroLote;
    private String complemento;
    private String bairro;
    private String localidade;
    private String UF;
}
