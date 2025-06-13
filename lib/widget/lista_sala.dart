import 'package:flutter/material.dart';
import 'package:flutter_application_1/Configuracao/rotas.dart';
import 'package:flutter_application_1/banco/sqlite/dao/dao_sala.dart';
import 'package:flutter_application_1/dto/dto_sala.dart';

class ListaSala extends StatefulWidget {
  const ListaSala({super.key});

  @override
  State<ListaSala> createState() => _ListaSalaState();
}

class _ListaSalaState extends State<ListaSala> {
  late List<DTOSala> _salas;
  final DAOSala _daoSala = DAOSala();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarSalas();
  }

  Future<void> _carregarSalas() async {
    try {
      final salas = await _daoSala.consultarTodos();
      setState(() {
        _salas = salas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar salas: $e')),
      );
    }
  }

  void _excluirSala(BuildContext context, DTOSala sala) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Sala'),
        content: Text(
          'Deseja excluir a sala ${sala.nome}?\n\n'
          'ID: ${sala.id}\n'
          'Capacidade Total: ${sala.capacidadeTotalBikes} bikes\n'
          'Número de Filas: ${sala.numeroFilas}\n'
          'Bikes por Fila: ${sala.numeroBikesPorFila}\n'
          'Status: ${sala.ativo ? 'Ativa' : 'Inativa'}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _daoSala.excluir(int.parse(sala.id!));
                await _carregarSalas();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sala excluída com sucesso')),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao excluir sala: $e')),
                );
              }
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _alterarSala(BuildContext context, DTOSala sala) {
    final _nomeController = TextEditingController(text: sala.nome);
    final _capacidadeController =
        TextEditingController(text: sala.capacidadeTotalBikes.toString());
    final _numeroFilasController =
        TextEditingController(text: sala.numeroFilas.toString());
    final _numeroBikesPorFilaController =
        TextEditingController(text: sala.numeroBikesPorFila.toString());
    bool _ativo = sala.ativo;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Alterar Sala'),
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
                    controller: _capacidadeController,
                    decoration: const InputDecoration(
                        labelText: 'Capacidade total de bikes *'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Capacidade é obrigatória';
                      }
                      final numero = int.tryParse(value.trim());
                      if (numero == null || numero < 0) {
                        return 'Capacidade deve ser um número inteiro válido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _numeroFilasController,
                    decoration:
                        const InputDecoration(labelText: 'Número de filas *'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Número de filas é obrigatório';
                      }
                      final numero = int.tryParse(value.trim());
                      if (numero == null || numero < 0) {
                        return 'Número de filas deve ser um número inteiro válido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _numeroBikesPorFilaController,
                    decoration: const InputDecoration(
                        labelText: 'Número de bikes por fila *'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Bikes por fila é obrigatório';
                      }
                      final numero = int.tryParse(value.trim());
                      if (numero == null || numero < 0) {
                        return 'Bikes por fila deve ser um número inteiro válido';
                      }
                      return null;
                    },
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
                      _capacidadeController.text.trim().isEmpty ||
                      _numeroFilasController.text.trim().isEmpty ||
                      _numeroBikesPorFilaController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Preencha todos os campos obrigatórios')),
                    );
                    return;
                  }
                  final capacidade =
                      int.tryParse(_capacidadeController.text.trim());
                  final filas =
                      int.tryParse(_numeroFilasController.text.trim());
                  final bikesPorFila =
                      int.tryParse(_numeroBikesPorFilaController.text.trim());
                  if (capacidade == null ||
                      filas == null ||
                      bikesPorFila == null ||
                      capacidade < 0 ||
                      filas < 0 ||
                      bikesPorFila < 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Valores numéricos inválidos')),
                    );
                    return;
                  }
                  try {
                    final updatedSala = DTOSala(
                      id: sala.id,
                      nome: _nomeController.text.trim(),
                      capacidadeTotalBikes: capacidade,
                      numeroFilas: filas,
                      numeroBikesPorFila: bikesPorFila,
                      ativo: _ativo,
                    );
                    await _daoSala.salvar(updatedSala);
                    await _carregarSalas();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Sala alterada com sucesso')),
                    );
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao alterar sala: $e')),
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
        title: const Text('Salas de Spinning'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _salas.isNotEmpty
              ? ListView.builder(
                  itemCount: _salas.length,
                  itemBuilder: (context, index) {
                    final sala = _salas[index];
                    return ListTile(
                      title: Text(sala.nome),
                      subtitle: Text(
                          'Capacidade: ${sala.capacidadeTotalBikes} bikes'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _alterarSala(context, sala),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _excluirSala(context, sala),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : const Center(child: Text('Nenhuma sala cadastrada')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, Rotas.formSala)
            .then((_) => _carregarSalas()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
