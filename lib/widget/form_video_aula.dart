import 'package:flutter/material.dart';
import 'package:flutter_application_1/dto/dto_video_aula.dart';

class FormVideoAula extends StatefulWidget {
  const FormVideoAula({super.key});

  @override
  State<FormVideoAula> createState() => _FormVideoAulaState();
}

class _FormVideoAulaState extends State<FormVideoAula> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _linkVideoController = TextEditingController();
  bool _ativo = true;

  @override
  void dispose() {
    _nomeController.dispose();
    _linkVideoController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final dto = DTOVideoAula(
        nome: _nomeController.text,
        linkVideo: _linkVideoController.text.isEmpty
            ? null
            : _linkVideoController.text,
        ativo: _ativo,
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dados do Vídeo Aula'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nome: ${dto.nome}'),
              Text('Link do Vídeo: ${dto.linkVideo ?? "Não informado"}'),
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
        title: const Text('Cadastro de Vídeo Aula'),
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
                  hintText: 'Digite o nome do vídeo aula',
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
                controller: _linkVideoController,
                decoration: const InputDecoration(
                  labelText: 'Link do Vídeo',
                  hintText: 'Digite o URL do vídeo (opcional)',
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!Uri.parse(value).isAbsolute) {
                      return 'Por favor, insira um URL válido';
                    }
                  }
                  return null;
                },
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
