import 'package:flutter/material.dart';
import 'package:flutter_application_1/Configuracao/rotas.dart';
import 'package:flutter_application_1/banco/sqlite/dao/dao_tipo_manutencao.dart';
import 'package:flutter_application_1/dto/dto_tipo_manutencao.dart';

class ListaTipoManutencao extends StatefulWidget {
  const ListaTipoManutencao({super.key});

  @override
  State<ListaTipoManutencao> createState() => _ListaTipoManutencaoState();
}

class _ListaTipoManutencaoState extends State<ListaTipoManutencao> {
  late List<DTOTipoManutencao> _tiposManutencao;
  final DAOTipoManutencao _daoTipoManutencao = DAOTipoManutencao();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarTiposManutencao();
  }

  Future<void> _carregarTiposManutencao() async {
    try {
      final tipos = await _daoTipoManutencao.consultarTodos();
      setState(() {
        _tiposManutencao = tipos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar tipos de manutenção: $e')),
      );
    }
  }

  void _excluirTipoManutencao(BuildContext context, DTOTipoManutencao tipo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Tipo de Manutenção'),
        content: Text(
          'Deseja excluir o tipo de manutenção ${tipo.nome}?\n\n'
          'ID: ${tipo.id}\n'
          'Descrição: ${tipo.descricao ?? 'N/A'}\n'
          'Status: ${tipo.ativo ? 'Ativo' : 'Inativo'}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _daoTipoManutencao.excluir(int.parse(tipo.id!));
                await _carregarTiposManutencao();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Tipo de manutenção excluído com sucesso')),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Erro ao excluir tipo de manutenção: $e')),
                );
              }
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _alterarTipoManutencao(BuildContext context, DTOTipoManutencao tipo) {
    final _nomeController = TextEditingController(text: tipo.nome);
    final _descricaoController = TextEditingController(text: tipo.descricao);
    bool _ativo = tipo.ativo;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Alterar Tipo de Manutenção'),
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
                    final updatedTipo = DTOTipoManutencao(
                      id: tipo.id,
                      nome: _nomeController.text.trim(),
                      descricao: _descricaoController.text.trim().isEmpty
                          ? null
                          : _descricaoController.text.trim(),
                      ativo: _ativo,
                    );
                    await _daoTipoManutencao.salvar(updatedTipo);
                    await _carregarTiposManutencao();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Tipo de manutenção alterado com sucesso')),
                    );
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Erro ao alterar tipo de manutenção: $e')),
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
        title: const Text('Tipos de Manutenção'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tiposManutencao.isNotEmpty
              ? ListView.builder(
                  itemCount: _tiposManutencao.length,
                  itemBuilder: (context, index) {
                    final tipo = _tiposManutencao[index];
                    return ListTile(
                      title: Text(tipo.nome),
                      subtitle: Text(tipo.descricao ?? 'Sem descrição'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () =>
                                _alterarTipoManutencao(context, tipo),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _excluirTipoManutencao(context, tipo),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text('Nenhum tipo de manutenção cadastrado')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, Rotas.formTipoManutencao)
            .then((_) => _carregarTiposManutencao()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
