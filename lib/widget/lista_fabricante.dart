import 'package:flutter/material.dart';
import 'package:flutter_application_1/Configuracao/rotas.dart';
import 'package:flutter_application_1/banco/sqlite/dao/dao_fabricante.dart';
import 'package:flutter_application_1/dto/dto_fabricante.dart';


// Widget da lista de fabricantes como StatefulWidget
class ListaFabricante extends StatefulWidget {
  const ListaFabricante({super.key});

  @override
  State<ListaFabricante> createState() => _ListaFabricanteState();
}

class _ListaFabricanteState extends State<ListaFabricante> {
  late List<DTOFabricante> _fabricantes;
  final DAOFabricante _daoFabricante = DAOFabricante();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarFabricantes();
  }

  // Função para carregar fabricantes do banco
  Future<void> _carregarFabricantes() async {
    try {
      final fabricantes = await _daoFabricante.consultarTodos();
      setState(() {
        _fabricantes = fabricantes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar fabricantes: $e')),
      );
    }
  }

  // Função para excluir fabricante
  void _excluirFabricante(BuildContext context, DTOFabricante fabricante) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Fabricante'),
        content: Text(
          'Deseja excluir o fabricante ${fabricante.nome}?\n\n'
          'ID: ${fabricante.id}\n'
          'Descrição: ${fabricante.descricao ?? 'N/A'}\n'
          'Contato: ${fabricante.nomeContatoPrincipal ?? 'N/A'}\n'
          'Email: ${fabricante.emailContato ?? 'N/A'}\n'
          'Telefone: ${fabricante.telefoneContato ?? 'N/A'}\n'
          'Status: ${fabricante.ativo ? 'Ativo' : 'Inativo'}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _daoFabricante.excluir(int.parse(fabricante.id!));
                await _carregarFabricantes();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Fabricante excluído com sucesso')),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao excluir fabricante: $e')),
                );
              }
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Função para alterar fabricante
  void _alterarFabricante(BuildContext context, DTOFabricante fabricante) {
    final _nomeController = TextEditingController(text: fabricante.nome);
    final _descricaoController =
        TextEditingController(text: fabricante.descricao);
    final _nomeContatoController =
        TextEditingController(text: fabricante.nomeContatoPrincipal);
    final _emailContatoController =
        TextEditingController(text: fabricante.emailContato);
    final _telefoneContatoController =
        TextEditingController(text: fabricante.telefoneContato);
    bool _ativo = fabricante.ativo;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Alterar Fabricante'),
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
                    controller: _descricaoController,
                    decoration: const InputDecoration(labelText: 'Descrição'),
                    maxLines: 2,
                  ),
                  TextFormField(
                    controller: _nomeContatoController,
                    decoration:
                        const InputDecoration(labelText: 'Nome do Contato'),
                  ),
                  TextFormField(
                    controller: _emailContatoController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return null;
                      final exp = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+\w{2,4}$');
                      if (!exp.hasMatch(value.trim())) {
                        return 'Informe um email válido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _telefoneContatoController,
                    decoration: const InputDecoration(labelText: 'Telefone'),
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
                  if (_nomeController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('O nome é obrigatório')),
                    );
                    return;
                  }
                  try {
                    final updatedFabricante = DTOFabricante(
                      id: fabricante.id,
                      nome: _nomeController.text.trim(),
                      descricao: _descricaoController.text.trim().isEmpty
                          ? null
                          : _descricaoController.text.trim(),
                      nomeContatoPrincipal:
                          _nomeContatoController.text.trim().isEmpty
                              ? null
                              : _nomeContatoController.text.trim(),
                      emailContato: _emailContatoController.text.trim().isEmpty
                          ? null
                          : _emailContatoController.text.trim(),
                      telefoneContato:
                          _telefoneContatoController.text.trim().isEmpty
                              ? null
                              : _telefoneContatoController.text.trim(),
                      ativo: _ativo,
                    );
                    await _daoFabricante.salvar(updatedFabricante);
                    await _carregarFabricantes();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Fabricante alterado com sucesso')),
                    );
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao alterar fabricante: $e')),
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
        title: const Text('Fabricantes de Spinning'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _fabricantes.isNotEmpty
              ? ListView.builder(
                  itemCount: _fabricantes.length,
                  itemBuilder: (context, index) {
                    final fabricante = _fabricantes[index];
                    return ListTile(
                      title: Text(fabricante.nome),
                      subtitle: Text(fabricante.descricao ?? 'Sem descrição'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () =>
                                _alterarFabricante(context, fabricante),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _excluirFabricante(context, fabricante),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : const Center(child: Text('Nenhum fabricante cadastrado')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, Rotas.formFabricante)
            .then((_) => _carregarFabricantes()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
