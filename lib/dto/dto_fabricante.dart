class DTOFabricante {
  final String? id;
  final String nome;
  final String? descricao;
  final String? nomeContatoPrincipal;
  final String? emailContato;
  final String? telefoneContato;
  final bool ativo;

  DTOFabricante({
    this.id,
    required this.nome,
    this.descricao,
    this.nomeContatoPrincipal,
    this.emailContato,
    this.telefoneContato,
    required this.ativo,
  });
}
