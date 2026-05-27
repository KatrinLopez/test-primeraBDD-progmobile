import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Databasehelper {
  static final Databasehelper _instance = Databasehelper._internal();
  Databasehelper._internal();

  factory Databasehelper(){
    return _instance;
  }

  static Database? _database;
  Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  Future<Database> _initDatabase() async{
    String dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath,"cadastro.db"),
      version: 1,
      onCreate: _onCreate,
    );
  }
  Future _onCreate(Database db, int version) async{
    await db.execute(
      'CREATE TABLE IF NOT EXISTS estudiante(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, matricula TEXT)');
    await db.execute(
      'CREATE TABLE IF NOT EXISTS disciplina(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, profesor TEXT)');
    await db.execute(
      'CREATE TABLE IF NOT EXISTS disciplina(id INTEGER PRIMARY KEY AUTOINCREMENT, estudante_id INTEGER, disciplina_id INTEGER, FOREIGN KEY(estudante_id) REFERENCES estudante(id), FOREIGN KEY(disciplina_id) REFERENCES disciplina(id))'
    );
  }
  
}
