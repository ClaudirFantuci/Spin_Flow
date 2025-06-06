class DTOSala {
  final String? id;
  final String nome;
  final int capacidadeTotalBikes;
  final int numeroFilas;
  final int numeroBikesPorFila;
  final bool ativo;

  DTOSala({
    this.id,
    required this.nome,
    required this.capacidadeTotalBikes,
    required this.numeroFilas,
    required this.numeroBikesPorFila,
    required this.ativo,
  });
}
