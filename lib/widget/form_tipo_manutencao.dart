import 'package:flutter/material.dart';
import '../dto/dto_tipo_manutencao.dart';

class FormTipoManutencao extends StatefulWidget {
  const FormTipoManutencao({super.key});

  @override
  State<FormTipoManutencao> createState() => _FormTipoManutencaoState();
}

class _FormTipoManutencaoState extends State<FormTipoManutencao> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  bool _ativo = true;

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final dto = DTOTipoManutencao(
        nome: _nomeController.text,
        descricao: _descricaoController.text.isEmpty
            ? null
            : _descricaoController.text,
        ativo: _ativo,
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dados do Tipo de Manutenção'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nome: ${dto.nome}'),
              Text('Descrição: ${dto.descricao ?? "Não informada"}'),
              Text('Ativo: ${dto.ativo ? "Sim" : "Não"}'),
            ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Tipo de Manutenção'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome *',
                  hintText: 'Digite o nome do tipo de manutenção',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O campo Nome é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Digite a descrição (opcional)',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Ativo'),
                value: _ativo,
                onChanged: (value) {
                  setState(() {
                    _ativo = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _salvar,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
