class DTOVideoAula {
  String? id;
  String nome;
  String? linkVideo;
  bool ativo;

  DTOVideoAula({
    this.id,
    required this.nome,
    this.linkVideo,
    this.ativo = true,
  });
}
