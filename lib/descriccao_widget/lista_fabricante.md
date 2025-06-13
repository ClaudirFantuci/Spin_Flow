para cada item no canto a direita inserir icone de excluir(vermelho) e alterar(laranja)
-criar uma função para excluir que apresente o dto.
-cria uma função para alteretar que apresente o dto.
- crie o mock de lista de dados do dto fabricante.
-crie o mock antes da classe widget- defina os dados no contexto coeso,que seria fabricantes de spinning.
-o nome da classe deve ser ListaFabricante

considere o seguinte dto:
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
