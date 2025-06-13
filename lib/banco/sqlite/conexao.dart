import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/banco/sqlite/script.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class Conexao {
  static Database? _db;

  static Future<Database> get() async {
    if (_db != null) return _db!;

    try {
      if (kIsWeb) {
        databaseFactory = databaseFactoryFfiWeb;
      }

      final path = join(await getDatabasesPath(), 'banco.db');
      // await deleteDatabase(path); // Comment out to persist data

      _db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          for (final sql in criarTabelas) {
            await db.execute(sql);
          }
          for (final insert in insertFabricantes) {
            await db.execute(insert);
          }
        },
      );

      return _db!;
    } catch (e) {
      throw Exception('Erro ao abrir o banco de dados: $e');
    }
  }
}
