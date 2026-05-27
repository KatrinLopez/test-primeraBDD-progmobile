import 'package:db2026/databaseHelper.dart';
import 'package:db2026/estudante.dart';


class estudanteDAO{
  final Databasehelper _databasehelper = Databasehelper();

  //insert
  Future<void> addEstudante(estudante e) async{
    final db = await _databasehelper.database;
    await db.insert ('estudante', e.toMap());
  }

  //update
  Future<void> updateEstudante(estudante e) async{
    final db = await _databasehelper.database;
    await db.update('estudante',
              e.toMap(),where:"id=?", whereArgs:[e.id]);
    }

  //delete
  Future<void> deleteEstudante(estudante e) async{
    final db = await _databasehelper.database;
    await db.delete('estudante',where:"id=?", whereArgs: [e.id]);
  }
  
  //select
  Future<List<estudante>> getEstudante()async{
    final db = await _databasehelper.database;
    final List<Map<String, dynamic>> maps =await db.query('estudante');
    return List.generate(maps.length,(index){
      return estudante.fromMap(maps[index]);
    });
  }
}