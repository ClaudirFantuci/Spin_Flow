import 'package:flutter_application_1/banco/sqlite/conexao.dart';
import 'package:flutter_application_1/dto/dto_aluno.dart';
import 'package:sqflite/sqflite.dart';

class DAOAluno {
  final String _sqlSalvar = '''
    INSERT OR REPLACE INTO Aluno (id, nome, email, data_nascimento, genero, telefone_contato, perfil_instagram, perfil_facebook, perfil_tiktok, ativo)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  ''';

  final String _sqlConsultarTodos = '''
    SELECT * FROM Aluno
  ''';

  final String _sqlConsultarPorId = '''
    SELECT * FROM Aluno WHERE id = ?
  ''';

  final String _sqlExcluir = '''
    DELETE FROM Aluno WHERE id = ?
  ''';

  Future<DTOAluno> _fromMap(Map<String, dynamic> map) async {
    return DTOAluno(
      id: map['id'],
      nome: map['nome'] as String,
      email: map['email'] as String,
      dataNascimento: map['data_nascimento'] as String,
      genero: map['genero'] as String,
      telefoneContato: map['telefone_contato'] as String,
      perfilInstagram: map['perfil_instagram'] as String?,
      perfilFacebook: map['perfil_facebook'] as String?,
      perfilTiktok: map['perfil_tiktok'] as String?,
      ativo: (map['ativo'] as int) == 1,
    );
  }

  Map<String, dynamic> _toMap(DTOAluno dto) {
    return {
      'id': dto.id,
      'nome': dto.nome,
      'email': dto.email,
      'data_nascimento': dto.dataNascimento,
      'genero': dto.genero,
      'telefone_contato': dto.telefoneContato,
      'perfil_instagram': dto.perfilInstagram,
      'perfil_facebook': dto.perfilFacebook,
      'perfil_tiktok': dto.perfilTiktok,
      'ativo': dto.ativo ? 1 : 0,
    };
  }

  Future<void> salvar(DTOAluno dto) async {
    final db = await Conexao.get();
    try {
      await db.rawInsert(_sqlSalvar, [
        dto.id,
        dto.nome,
        dto.email,
        dto.dataNascimento,
        dto.genero,
        dto.telefoneContato,
        dto.perfilInstagram,
        dto.perfilFacebook,
        dto.perfilTiktok,
        dto.ativo ? 1 : 0,
      ]);
    } catch (e) {
      throw Exception('Erro ao salvar aluno: $e');
    }
  }

  Future<List<DTOAluno>> consultarTodos() async {
    final db = await Conexao.get();
    try {
      final List<Map<String, dynamic>> maps =
          await db.rawQuery(_sqlConsultarTodos);
      return Future.wait(maps.map((map) => _fromMap(map)));
    } catch (e) {
      throw Exception('Erro ao consultar alunos: $e');
    }
  }

  Future<DTOAluno?> consultarPorId(int id) async {
    final db = await Conexao.get();
    try {
      final List<Map<String, dynamic>> maps =
          await db.rawQuery(_sqlConsultarPorId, [id]);
      if (maps.isNotEmpty) {
        return await _fromMap(maps.first);
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao consultar aluno por ID: $e');
    }
  }

  Future<void> excluir(int id) async {
    final db = await Conexao.get();
    try {
      await db.rawDelete(_sqlExcluir, [id]);
    } catch (e) {
      throw Exception('Erro ao excluir aluno: $e');
    }
  }
}
