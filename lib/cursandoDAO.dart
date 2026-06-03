import 'package:db2026/databaseHelper.dart';
import 'package:db2026/cursando.dart';

class cursandoDAO {
  final Databasehelper _databasehelper = Databasehelper();

  // INSERT
  Future<void> addCursando(Cursando c) async {
    final db = await _databasehelper.database;
    await db.insert('cursando', c.toMap());
  }

  // DELETE
  Future<void> deleteCursando(int id) async {
    final db = await _databasehelper.database;
    await db.delete(
      'cursando',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // SELECT ALL
  Future<List<Cursando>> getCursando() async {
    final db = await _databasehelper.database;
    final List<Map<String, dynamic>> maps = await db.query('cursando');

    return List.generate(maps.length, (i) {
      return Cursando.fromMap(maps[i]);
    });
  }

  // JOIN 
  Future<List<Map<String, dynamic>>> getRelatorio() async {
    final db = await _databasehelper.database;
    return await db.rawQuery('''
      SELECT
        cursando.id,
        estudante.nome AS estudante,
        disciplina.nome AS disciplina,
        disciplina.profesor AS profesor
      FROM cursando
      INNER JOIN estudante
        ON estudante.id = cursando.estudante_id
      INNER JOIN disciplina
        ON disciplina.id = cursando.disciplina_id
    ''');
  }
}