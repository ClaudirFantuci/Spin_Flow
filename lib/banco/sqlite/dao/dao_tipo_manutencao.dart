import 'package:flutter_application_1/banco/sqlite/conexao.dart';
import 'package:flutter_application_1/dto/dto_tipo_manutencao.dart';
import 'package:sqflite/sqflite.dart';

class DAOTipoManutencao {
  final String _sqlSalvar = '''
    INSERT OR REPLACE INTO tipo_manutencao (id, nome, descricao, ativo)
    VALUES (?, ?, ?, ?)
  ''';

  final String _sqlConsultarTodos = '''
    SELECT * FROM tipo_manutencao
  ''';

  final String _sqlConsultarPorId = '''
    SELECT * FROM tipo_manutencao WHERE id = ?
  ''';

  final String _sqlExcluir = '''
    DELETE FROM tipo_manutencao WHERE id = ?
  ''';

  Future<DTOTipoManutencao> _fromMap(Map<String, dynamic> map) async {
    return DTOTipoManutencao(
      id: map['id'].toString(),
      nome: map['nome'] as String,
      descricao: map['descricao'] as String?,
      ativo: (map['ativo'] as int) == 1,
    );
  }

  Map<String, dynamic> _toMap(DTOTipoManutencao dto) {
    return {
      'id': dto.id != null ? int.parse(dto.id!) : null,
      'nome': dto.nome,
      'descricao': dto.descricao,
      'ativo': dto.ativo ? 1 : 0,
    };
  }

  Future<void> salvar(DTOTipoManutencao dto) async {
    final db = await Conexao.get();
    try {
      await db.rawInsert(_sqlSalvar, [
        dto.id != null ? int.parse(dto.id!) : null,
        dto.nome,
        dto.descricao,
        dto.ativo ? 1 : 0,
      ]);
    } catch (e) {
      throw Exception('Erro ao salvar tipo de manutenção: $e');
    }
  }

  Future<List<DTOTipoManutencao>> consultarTodos() async {
    final db = await Conexao.get();
    try {
      final List<Map<String, dynamic>> maps =
          await db.rawQuery(_sqlConsultarTodos);
      return Future.wait(maps.map((map) => _fromMap(map)));
    } catch (e) {
      throw Exception('Erro ao consultar tipos de manutenção: $e');
    }
  }

  Future<DTOTipoManutencao?> consultarPorId(int id) async {
    final db = await Conexao.get();
    try {
      final List<Map<String, dynamic>> maps =
          await db.rawQuery(_sqlConsultarPorId, [id]);
      if (maps.isNotEmpty) {
        return await _fromMap(maps.first);
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao consultar tipo de manutenção por ID: $e');
    }
  }

  Future<void> excluir(int id) async {
    final db = await Conexao.get();
    try {
      await db.rawDelete(_sqlExcluir, [id]);
    } catch (e) {
      throw Exception('Erro ao excluir tipo de manutenção: $e');
    }
  }
}
