import 'package:flutter_application_1/banco/sqlite/conexao.dart';
import 'package:flutter_application_1/dto/dto_sala.dart';
import 'package:sqflite/sqflite.dart';

class DAOSala {
  final String _sqlSalvar = '''
    INSERT OR REPLACE INTO sala (id, nome, capacidade_total_bikes, numero_filas, numero_bikes_por_fila, ativo)
    VALUES (?, ?, ?, ?, ?, ?)
  ''';

  final String _sqlConsultarTodos = '''
    SELECT * FROM sala
  ''';

  final String _sqlConsultarPorId = '''
    SELECT * FROM sala WHERE id = ?
  ''';

  final String _sqlExcluir = '''
    DELETE FROM sala WHERE id = ?
  ''';

  Future<DTOSala> _fromMap(Map<String, dynamic> map) async {
    return DTOSala(
      id: map['id'].toString(),
      nome: map['nome'] as String,
      capacidadeTotalBikes: map['capacidade_total_bikes'] as int,
      numeroFilas: map['numero_filas'] as int,
      numeroBikesPorFila: map['numero_bikes_por_fila'] as int,
      ativo: (map['ativo'] as int) == 1,
    );
  }

  Map<String, dynamic> _toMap(DTOSala dto) {
    return {
      'id': dto.id != null ? int.parse(dto.id!) : null,
      'nome': dto.nome,
      'capacidade_total_bikes': dto.capacidadeTotalBikes,
      'numero_filas': dto.numeroFilas,
      'numero_bikes_por_fila': dto.numeroBikesPorFila,
      'ativo': dto.ativo ? 1 : 0,
    };
  }

  Future<void> salvar(DTOSala dto) async {
    final db = await Conexao.get();
    try {
      await db.rawInsert(_sqlSalvar, [
        dto.id != null ? int.parse(dto.id!) : null,
        dto.nome,
        dto.capacidadeTotalBikes,
        dto.numeroFilas,
        dto.numeroBikesPorFila,
        dto.ativo ? 1 : 0,
      ]);
    } catch (e) {
      throw Exception('Erro ao salvar sala: $e');
    }
  }

  Future<List<DTOSala>> consultarTodos() async {
    final db = await Conexao.get();
    try {
      final List<Map<String, dynamic>> maps =
          await db.rawQuery(_sqlConsultarTodos);
      return Future.wait(maps.map((map) => _fromMap(map)));
    } catch (e) {
      throw Exception('Erro ao consultar salas: $e');
    }
  }

  Future<DTOSala?> consultarPorId(int id) async {
    final db = await Conexao.get();
    try {
      final List<Map<String, dynamic>> maps =
          await db.rawQuery(_sqlConsultarPorId, [id]);
      if (maps.isNotEmpty) {
        return await _fromMap(maps.first);
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao consultar sala por ID: $e');
    }
  }

  Future<void> excluir(int id) async {
    final db = await Conexao.get();
    try {
      await db.rawDelete(_sqlExcluir, [id]);
    } catch (e) {
      throw Exception('Erro ao excluir sala: $e');
    }
  }
}
