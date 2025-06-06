import 'package:flutter/material.dart';
import 'package:flutter_application_1/dto/dto_aluno.dart';
import 'package:intl/intl.dart';

class FormAluno extends StatefulWidget {
  const FormAluno({super.key});

  @override
  State<FormAluno> createState() => _FormAlunoState();
}

class _FormAlunoState extends State<FormAluno> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  String? _genero;
  final _telefoneContatoController = TextEditingController();
  final _perfilInstagramController = TextEditingController();
  final _perfilFacebookController = TextEditingController();
  final _perfilTiktokController = TextEditingController();
  bool _ativo = true;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _dataNascimentoController.dispose();
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
        nome: _nomeController.text,
        email: _emailController.text,
        dataNascimento: _dataNascimentoController.text,
        genero: _genero!,
        telefoneContato: _telefoneContatoController.text,
        perfilInstagram: _perfilInstagramController.text.isEmpty
            ? null
            : _perfilInstagramController.text,
        perfilFacebook: _perfilFacebookController.text.isEmpty
            ? null
            : _perfilFacebookController.text,
        perfilTiktok: _perfilTiktokController.text.isEmpty
            ? null
            : _perfilTiktokController.text,
        ativo: _ativo,
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dados do Aluno'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nome: ${dto.nome}'),
              Text('Email: ${dto.email}'),
              Text('Data de Nascimento: ${dto.dataNascimento}'),
              Text('Gênero: ${dto.genero}'),
              Text('Telefone: ${dto.telefoneContato}'),
              Text('Instagram: ${dto.perfilInstagram ?? "Não informado"}'),
              Text('Facebook: ${dto.perfilFacebook ?? "Não informado"}'),
              Text('TikTok: ${dto.perfilTiktok ?? "Não informado"}'),
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
        title: const Text('Cadastro de Aluno'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome *',
                    hintText: 'Digite o nome completo',
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
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email *',
                    hintText: 'Digite o email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O campo Email é obrigatório';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Por favor, insira um email válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dataNascimentoController,
                  decoration: const InputDecoration(
                    labelText: 'Data de Nascimento *',
                    hintText: 'AAAA-MM-DD',
                  ),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O campo Data de Nascimento é obrigatório';
                    }
                    try {
                      DateFormat('yyyy-MM-dd').parseStrict(value);
                    } catch (e) {
                      return 'Formato inválido. Use AAAA-MM-DD';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _genero,
                  decoration: const InputDecoration(
                    labelText: 'Gênero *',
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'Masculino', child: Text('Masculino')),
                    DropdownMenuItem(
                        value: 'Feminino', child: Text('Feminino')),
                    DropdownMenuItem(value: 'Outro', child: Text('Outro')),
                    DropdownMenuItem(
                        value: 'Prefiro não informar',
                        child: Text('Prefiro não informar')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _genero = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'O campo Gênero é obrigatório';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _telefoneContatoController,
                  decoration: const InputDecoration(
                    labelText: 'Telefone de Contato *',
                    hintText: '(##) #####-####',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O campo Telefone é obrigatório';
                    }
                    if (!RegExp(r'^\(\d{2}\) \d{5}-\d{4}$').hasMatch(value)) {
                      return 'Formato inválido. Use (##) #####-####';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _perfilInstagramController,
                  decoration: const InputDecoration(
                    labelText: 'Perfil Instagram',
                    hintText: 'Digite o perfil do Instagram (opcional)',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _perfilFacebookController,
                  decoration: const InputDecoration(
                    labelText: 'Perfil Facebook',
                    hintText: 'Digite o perfil do Facebook (opcional)',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _perfilTiktokController,
                  decoration: const InputDecoration(
                    labelText: 'Perfil TikTok',
                    hintText: 'Digite o perfil do TikTok (opcional)',
                  ),
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
      ),
    );
  }
}
