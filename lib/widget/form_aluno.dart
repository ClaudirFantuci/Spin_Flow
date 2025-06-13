import 'package:flutter/material.dart';
import 'package:flutter_application_1/Configuracao/rotas.dart';
import 'package:flutter_application_1/banco/sqlite/dao/dao_aluno.dart';
import 'package:flutter_application_1/dto/dto_aluno.dart';

class FormAluno extends StatefulWidget {
  const FormAluno({Key? key}) : super(key: key);

  @override
  State<FormAluno> createState() => _FormAlunoState();
}

class _FormAlunoState extends State<FormAluno> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _generoController = TextEditingController();
  final _telefoneContatoController = TextEditingController();
  final _perfilInstagramController = TextEditingController();
  final _perfilFacebookController = TextEditingController();
  final _perfilTiktokController = TextEditingController();
  bool _ativo = true;
  final DAOAluno _daoAluno = DAOAluno();

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _dataNascimentoController.dispose();
    _generoController.dispose();
    _telefoneContatoController.dispose();
    _perfilInstagramController.dispose();
    _perfilFacebookController.dispose();
    _perfilTiktokController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final dto = DTOAluno(
        id: null,
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        dataNascimento: _dataNascimentoController.text.trim(),
        genero: _generoController.text.trim(),
        telefoneContato: _telefoneContatoController.text.trim(),
        perfilInstagram: _perfilInstagramController.text.trim().isEmpty
            ? null
            : _perfilInstagramController.text.trim(),
        perfilFacebook: _perfilFacebookController.text.trim().isEmpty
            ? null
            : _perfilFacebookController.text.trim(),
        perfilTiktok: _perfilTiktokController.text.trim().isEmpty
            ? null
            : _perfilTiktokController.text.trim(),
        ativo: _ativo,
      );
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmar Cadastro'),
          content: Text(
            'Nome: ${dto.nome}\n'
            'Email: ${dto.email}\n'
            'Data de Nascimento: ${dto.dataNascimento}\n'
            'Gênero: ${dto.genero}\n'
            'Telefone: ${dto.telefoneContato}\n'
            'Instagram: ${dto.perfilInstagram ?? "-"}\n'
            'Facebook: ${dto.perfilFacebook ?? "-"}\n'
            'TikTok: ${dto.perfilTiktok ?? "-"}\n'
            'Ativo: ${dto.ativo ? "Sim" : "Não"}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await _daoAluno.salvar(dto);
                  Navigator.pop(context);
                  Navigator.pushNamed(context, Rotas.listaAluno);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Aluno cadastrado com sucesso')),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao cadastrar aluno: $e')),
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

  String? _validarNome(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'O nome é obrigatório';
    }
    return null;
  }

  String? _validarEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'O email é obrigatório';
    }
    final exp = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+\w{2,4}$');
    if (!exp.hasMatch(value.trim())) {
      return 'Informe um email válido';
    }
    return null;
  }

  String? _validarDataNascimento(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'A data de nascimento é obrigatória';
    }
    return null;
  }

  String? _validarGenero(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'O gênero é obrigatório';
    }
    return null;
  }

  String? _validarTelefone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'O telefone é obrigatório';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Aluno'),
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
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email *',
                border: OutlineInputBorder(),
              ),
              validator: _validarEmail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dataNascimentoController,
              decoration: const InputDecoration(
                labelText: 'Data de Nascimento *',
                border: OutlineInputBorder(),
              ),
              validator: _validarDataNascimento,
              keyboardType: TextInputType.datetime,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _generoController,
              decoration: const InputDecoration(
                labelText: 'Gênero *',
                border: OutlineInputBorder(),
              ),
              validator: _validarGenero,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _telefoneContatoController,
              decoration: const InputDecoration(
                labelText: 'Telefone *',
                border: OutlineInputBorder(),
              ),
              validator: _validarTelefone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _perfilInstagramController,
              decoration: const InputDecoration(
                labelText: 'Perfil Instagram',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _perfilFacebookController,
              decoration: const InputDecoration(
                labelText: 'Perfil Facebook',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _perfilTiktokController,
              decoration: const InputDecoration(
                labelText: 'Perfil TikTok',
                border: OutlineInputBorder(),
              ),
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
