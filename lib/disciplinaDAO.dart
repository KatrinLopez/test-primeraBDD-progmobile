import 'package:db2026/databaseHelper.dart';
import 'package:db2026/disciplina.dart';

class disciplinaDAO {
   final Databasehelper _databasehelper = Databasehelper();

   // insert
  Future<void> addDisciplina(Disciplina e) async{
    final db = await _databasehelper.database;
    await db.insert('disciplina', e.toMap());
  }

  // update
  Future<void> updateDisciplina(Disciplina e) async{
    final db = await _databasehelper.database;
    await db.update(
      'disciplina',
      e.toMap(),
      where: "id=?", 
      whereArgs: [e.id],
    );
  }

  // delete 
  Future<void> deleteDisciplina(int id) async{
    final db = await _databasehelper.database;
    await db.delete('disciplina', where: "id=?", whereArgs: [id]);
  }
  
// select 
  Future<List<Disciplina>> getDisciplina() async {
    final db = await _databasehelper.database;
    final List<Map<String, dynamic>> maps = await db.query('disciplina');
    
    return List.generate(maps.length, (index) {
      return Disciplina.fromMap(maps[index]);
    }); // <-- Paréntesis y punto y coma aquí
  }
}