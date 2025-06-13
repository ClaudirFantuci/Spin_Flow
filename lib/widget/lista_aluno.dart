import 'package:flutter/material.dart';
import 'package:flutter_application_1/Configuracao/rotas.dart';
import 'package:flutter_application_1/banco/sqlite/dao/dao_aluno.dart';
import 'package:flutter_application_1/dto/dto_aluno.dart';

class ListaAluno extends StatefulWidget {
  const ListaAluno({super.key});

  @override
  State<ListaAluno> createState() => _ListaAlunoState();
}

class _ListaAlunoState extends State<ListaAluno> {
  late List<DTOAluno> _alunos;
  final DAOAluno _daoAluno = DAOAluno();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarAlunos();
  }

  Future<void> _carregarAlunos() async {
    try {
      final alunos = await _daoAluno.consultarTodos();
      setState(() {
        _alunos = alunos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar alunos: $e')),
      );
    }
  }

  void _excluirAluno(BuildContext context, DTOAluno aluno) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Aluno'),
        content: Text(
          'Deseja excluir o aluno ${aluno.nome}?\n\n'
          'ID: ${aluno.id}\n'
          'Email: ${aluno.email}\n'
          'Data de Nascimento: ${aluno.dataNascimento}\n'
          'Gênero: ${aluno.genero}\n'
          'Telefone: ${aluno.telefoneContato}\n'
          'Instagram: ${aluno.perfilInstagram ?? 'N/A'}\n'
          'Facebook: ${aluno.perfilFacebook ?? 'N/A'}\n'
          'TikTok: ${aluno.perfilTiktok ?? 'N/A'}\n'
          'Status: ${aluno.ativo ? 'Ativo' : 'Inativo'}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _daoAluno.excluir(int.parse(aluno.id!));
                await _carregarAlunos();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Aluno excluído com sucesso')),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao excluir aluno: $e')),
                );
              }
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _alterarAluno(BuildContext context, DTOAluno aluno) {
    final _nomeController = TextEditingController(text: aluno.nome);
    final _emailController = TextEditingController(text: aluno.email);
    final _dataNascimentoController =
        TextEditingController(text: aluno.dataNascimento);
    final _generoController = TextEditingController(text: aluno.genero);
    final _telefoneContatoController =
        TextEditingController(text: aluno.telefoneContato);
    final _perfilInstagramController =
        TextEditingController(text: aluno.perfilInstagram);
    final _perfilFacebookController =
        TextEditingController(text: aluno.perfilFacebook);
    final _perfilTiktokController =
        TextEditingController(text: aluno.perfilTiktok);
    bool _ativo = aluno.ativo;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Alterar Aluno'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(labelText: 'Nome *'),
                    validator: (value) =>
                        value!.trim().isEmpty ? 'O nome é obrigatório' : null,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email *'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'O email é obrigatório';
                      }
                      final exp = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+\w{2,4}$');
                      if (!exp.hasMatch(value.trim())) {
                        return 'Informe um email válido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _dataNascimentoController,
                    decoration: const InputDecoration(
                        labelText: 'Data de Nascimento *'),
                    validator: (value) => value!.trim().isEmpty
                        ? 'A data de nascimento é obrigatória'
                        : null,
                  ),
                  TextFormField(
                    controller: _generoController,
                    decoration: const InputDecoration(labelText: 'Gênero *'),
                    validator: (value) =>
                        value!.trim().isEmpty ? 'O gênero é obrigatório' : null,
                  ),
                  TextFormField(
                    controller: _telefoneContatoController,
                    decoration: const InputDecoration(labelText: 'Telefone *'),
                    validator: (value) => value!.trim().isEmpty
                        ? 'O telefone é obrigatório'
                        : null,
                  ),
                  TextFormField(
                    controller: _perfilInstagramController,
                    decoration:
                        const InputDecoration(labelText: 'Perfil Instagram'),
                  ),
                  TextFormField(
                    controller: _perfilFacebookController,
                    decoration:
                        const InputDecoration(labelText: 'Perfil Facebook'),
                  ),
                  TextFormField(
                    controller: _perfilTiktokController,
                    decoration:
                        const InputDecoration(labelText: 'Perfil TikTok'),
                  ),
                  SwitchListTile(
                    title: const Text('Ativo'),
                    value: _ativo,
                    onChanged: (v) => setDialogState(() => _ativo = v),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  if (_nomeController.text.trim().isEmpty ||
                      _emailController.text.trim().isEmpty ||
                      _dataNascimentoController.text.trim().isEmpty ||
                      _generoController.text.trim().isEmpty ||
                      _telefoneContatoController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Campos obrigatórios não preenchidos')),
                    );
                    return;
                  }
                  try {
                    final updatedAluno = DTOAluno(
                      id: aluno.id,
                      nome: _nomeController.text.trim(),
                      email: _emailController.text.trim(),
                      dataNascimento: _dataNascimentoController.text.trim(),
                      genero: _generoController.text.trim(),
                      telefoneContato: _telefoneContatoController.text.trim(),
                      perfilInstagram:
                          _perfilInstagramController.text.trim().isEmpty
                              ? null
                              : _perfilInstagramController.text.trim(),
                      perfilFacebook:
                          _perfilFacebookController.text.trim().isEmpty
                              ? null
                              : _perfilFacebookController.text.trim(),
                      perfilTiktok: _perfilTiktokController.text.trim().isEmpty
                          ? null
                          : _perfilTiktokController.text.trim(),
                      ativo: _ativo,
                    );
                    await _daoAluno.salvar(updatedAluno);
                    await _carregarAlunos();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Aluno alterado com sucesso')),
                    );
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao alterar aluno: $e')),
                    );
                  }
                },
                child: const Text('Salvar',
                    style: TextStyle(color: Colors.orange)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Alunos'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _alunos.isNotEmpty
              ? ListView.builder(
                  itemCount: _alunos.length,
                  itemBuilder: (context, index) {
                    final aluno = _alunos[index];
                    return ListTile(
                      title: Text(aluno.nome),
                      subtitle: Text(aluno.email),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _alterarAluno(context, aluno),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _excluirAluno(context, aluno),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : const Center(child: Text('Nenhum aluno cadastrado')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, Rotas.formAluno)
            .then((_) => _carregarAlunos()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
