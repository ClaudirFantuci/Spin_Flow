import 'package:flutter/material.dart';
import 'package:flutter_application_1/dto/dto_fabricante.dart';

class FormFabricante extends StatefulWidget {
  const FormFabricante({Key? key}) : super(key: key);

  @override
  State<FormFabricante> createState() => _FormFabricanteState();
}

class _FormFabricanteState extends State<FormFabricante> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _nomeContatoController = TextEditingController();
  final _emailContatoController = TextEditingController();
  final _telefoneContatoController = TextEditingController();
  bool _ativo = true;

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _nomeContatoController.dispose();
    _emailContatoController.dispose();
    _telefoneContatoController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final dto = DTOFabricante(
        nome: _nomeController.text.trim(),
        descricao: _descricaoController.text.trim().isEmpty
            ? null
            : _descricaoController.text.trim(),
        nomeContatoPrincipal: _nomeContatoController.text.trim().isEmpty
            ? null
            : _nomeContatoController.text.trim(),
        emailContato: _emailContatoController.text.trim().isEmpty
            ? null
            : _emailContatoController.text.trim(),
        telefoneContato: _telefoneContatoController.text.trim().isEmpty
            ? null
            : _telefoneContatoController.text.trim(),
        ativo: _ativo,
      );
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dados do Fabricante'),
          content: Text(
            'Nome: ${dto.nome}\n'
            'Descrição: ${dto.descricao ?? "-"}\n'
            'Nome Contato Principal: ${dto.nomeContatoPrincipal ?? "-"}\n'
            'Email Contato: ${dto.emailContato ?? "-"}\n'
            'Telefone Contato: ${dto.telefoneContato ?? "-"}\n'
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

  String? _validarEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final exp = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+\w{2,4}$');
    if (!exp.hasMatch(value.trim())) {
      return 'Informe um email válido';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Fabricante'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome fantasia *',
                border: OutlineInputBorder(),
              ),
              validator: _validarNome,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nomeContatoController,
              decoration: const InputDecoration(
                labelText: 'Nome do contato principal',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailContatoController,
              decoration: const InputDecoration(
                labelText: 'Email do contato',
                border: OutlineInputBorder(),
              ),
              validator: _validarEmail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _telefoneContatoController,
              decoration: const InputDecoration(
                labelText: 'Telefone do contato',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
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
