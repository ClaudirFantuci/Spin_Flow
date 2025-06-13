import 'package:flutter/material.dart';
import 'package:flutter_application_1/Configuracao/rotas.dart';
import 'package:flutter_application_1/banco/sqlite/dao/dao_tipo_manutencao.dart';
import 'package:flutter_application_1/dto/dto_tipo_manutencao.dart';

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
  final DAOTipoManutencao _daoTipoManutencao = DAOTipoManutencao();

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final dto = DTOTipoManutencao(
        id: null, // ID será gerado pelo banco
        nome: _nomeController.text.trim(),
        descricao: _descricaoController.text.trim().isEmpty
            ? null
            : _descricaoController.text.trim(),
        ativo: _ativo,
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmar Cadastro'),
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
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await _daoTipoManutencao.salvar(dto);
                  Navigator.pop(context);
                  Navigator.pushNamed(context, Rotas.listaTipoManutencao);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Tipo de manutenção cadastrado com sucesso')),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Erro ao cadastrar tipo de manutenção: $e')),
                  );
                }
              },
              child: const Text('Confirmar'),
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
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
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
                  border: OutlineInputBorder(),
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
