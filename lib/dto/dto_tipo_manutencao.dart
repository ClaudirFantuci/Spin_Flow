class DTOTipoManutencao {
  String? id;
  String nome;
  String? descricao;
  bool ativo;

  DTOTipoManutencao({
    this.id,
    required this.nome,
    this.descricao,
    this.ativo = true,
  });
}
