class DTOAluno {
  String? id;
  String nome;
  String email;
  String dataNascimento;
  String genero;
  String telefoneContato;
  String? perfilInstagram;
  String? perfilFacebook;
  String? perfilTiktok;
  bool ativo;

  DTOAluno({
    this.id,
    required this.nome,
    required this.email,
    required this.dataNascimento,
    required this.genero,
    required this.telefoneContato,
    this.perfilInstagram,
    this.perfilFacebook,
    this.perfilTiktok,
    this.ativo = true,
  });
}
