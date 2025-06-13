import 'package:flutter_application_1/banco/sqlite/conexao.dart';
import 'package:flutter_application_1/dto/dto_fabricante.dart';
import 'package:sqflite/sqflite.dart';

class DAOFabricante {
  final String _sqlSalvar = '''
    INSERT OR REPLACE INTO Fabricante (id, nome, descricao, nome_contato_principal, email_contato, telefone_contato, ativo)
    VALUES (?, ?, ?, ?, ?, ?, ?)
  ''';

  final String _sqlConsultarTodos = '''
    SELECT * FROM Fabricante
  ''';

  final String _sqlConsultarPorId = '''
    SELECT * FROM Fabricante WHERE id = ?
  ''';

  final String _sqlExcluir = '''
    DELETE FROM Fabricante WHERE id = ?
  ''';

  Future<DTOFabricante> _fromMap(Map<String, dynamic> map) async {
    return DTOFabricante(
      id: map['id'],
      nome: map['nome'] as String,
      descricao: map['descricao'] as String?,
      nomeContatoPrincipal: map['nome_contato_principal'] as String?,
      emailContato: map['email_contato'] as String?,
      telefoneContato: map['telefone_contato'] as String?,
      ativo: (map['ativo'] as int) == 1,
    );
  }

  Map<String, dynamic> _toMap(DTOFabricante dto) {
    return {
      'id': dto.id,
      'nome': dto.nome,
      'descricao': dto.descricao,
      'nome_contato_principal': dto.nomeContatoPrincipal,
      'email_contato': dto.emailContato,
      'telefone_contato': dto.telefoneContato,
      'ativo': dto.ativo ? 1 : 0,
    };
  }

  Future<void> salvar(DTOFabricante dto) async {
    throw Exception('Simulated error');
    final db = await Conexao.get();
    try {
      await db.rawInsert(_sqlSalvar, [
        dto.id,
        dto.nome,
        dto.descricao,
        dto.nomeContatoPrincipal,
        dto.emailContato,
        dto.telefoneContato,
        dto.ativo ? 1 : 0,
      ]);
    } catch (e) {
      throw Exception('Erro ao salvar fabricante: $e');
    }
  }

  Future<List<DTOFabricante>> consultarTodos() async {
    final db = await Conexao.get();
    try {
      final List<Map<String, dynamic>> maps =
          await db.rawQuery(_sqlConsultarTodos);
      return Future.wait(maps.map((map) => _fromMap(map)));
    } catch (e) {
      throw Exception('Erro ao consultar fabricantes: $e');
    }
  }

  Future<DTOFabricante?> consultarPorId(int id) async {
    final db = await Conexao.get();
    try {
      final List<Map<String, dynamic>> maps =
          await db.rawQuery(_sqlConsultarPorId, [id]);
      if (maps.isNotEmpty) {
        return await _fromMap(maps.first);
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao consultar fabricante por ID: $e');
    }
  }

  Future<void> excluir(int id) async {
    final db = await Conexao.get();
    try {
      await db.rawDelete(_sqlExcluir, [id]);
    } catch (e) {
      throw Exception('Erro ao excluir fabricante: $e');
    }
  }
}
