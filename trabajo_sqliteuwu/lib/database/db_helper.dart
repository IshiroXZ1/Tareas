import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/estudiante.dart';

class DbHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'estudiantes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE estudiantes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            edad INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  static Future<void> insertar(Estudiante e) async {
    final db = await database;
    await db.insert(
      'estudiantes',
      e.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Estudiante>> obtenerTodos() async {
    final db = await database;
    final lista = await db.query('estudiantes', orderBy: 'id DESC');
    return lista.map((e) => Estudiante.fromMap(e)).toList();
  }

  static Future<void> actualizar(Estudiante e) async {
    final db = await database;
    await db.update(
      'estudiantes',
      e.toMap(),
      where: 'id = ?',
      whereArgs: [e.id],
    );
  }

  static Future<void> eliminar(int id) async {
    final db = await database;
    await db.delete('estudiantes', where: 'id = ?', whereArgs: [id]);
  }
}
