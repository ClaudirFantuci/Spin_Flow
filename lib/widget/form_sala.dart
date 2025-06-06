import 'package:flutter/material.dart';
import 'package:flutter_application_1/dto/dto_sala.dart';

class FormSala extends StatefulWidget {
  const FormSala({Key? key}) : super(key: key);

  @override
  State<FormSala> createState() => _FormSalaState();
}

class _FormSalaState extends State<FormSala> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _capacidadeController = TextEditingController();
  final _numeroFilasController = TextEditingController();
  final _numeroBikesPorFilaController = TextEditingController();
  bool _ativo = true;

  @override
  void dispose() {
    _nomeController.dispose();
    _capacidadeController.dispose();
    _numeroFilasController.dispose();
    _numeroBikesPorFilaController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final dto = DTOSala(
        nome: _nomeController.text.trim(),
        capacidadeTotalBikes: int.parse(_capacidadeController.text.trim()),
        numeroFilas: int.parse(_numeroFilasController.text.trim()),
        numeroBikesPorFila:
            int.parse(_numeroBikesPorFilaController.text.trim()),
        ativo: _ativo,
      );
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dados da Sala'),
          content: Text(
            'Nome: ${dto.nome}\n'
            'Capacidade total de bikes: ${dto.capacidadeTotalBikes}\n'
            'Número de filas: ${dto.numeroFilas}\n'
            'Número de bikes por fila: ${dto.numeroBikesPorFila}\n'
            'Ativo: ${dto.ativo ? "Sim" : "Não"}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  String? _validarNome(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'O nome é obrigatório';
    }
    return null;
  }

  String? _validarIntObrigatorio(String? value, String campo) {
    if (value == null || value.trim().isEmpty) {
      return '$campo é obrigatório';
    }
    final numero = int.tryParse(value.trim());
    if (numero == null || numero < 0) {
      return '$campo deve ser um número inteiro válido';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Sala'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome *',
                border: OutlineInputBorder(),
              ),
              validator: _validarNome,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _capacidadeController,
              decoration: const InputDecoration(
                labelText: 'Capacidade total de bikes *',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  _validarIntObrigatorio(v, 'Capacidade total de bikes'),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _numeroFilasController,
              decoration: const InputDecoration(
                labelText: 'Número de filas *',
                border: OutlineInputBorder(),
              ),
              validator: (v) => _validarIntObrigatorio(v, 'Número de filas'),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _numeroBikesPorFilaController,
              decoration: const InputDecoration(
                labelText: 'Número de bikes por fila *',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  _validarIntObrigatorio(v, 'Número de bikes por fila'),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Ativo'),
              value: _ativo,
              onChanged: (v) => setState(() => _ativo = v),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _salvar,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
