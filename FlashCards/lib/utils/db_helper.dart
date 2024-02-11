import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const String _databaseName = 'quiz.db';
  static const int _databaseVersion = 1;
  DBHelper._();
  static final DBHelper _singleton = DBHelper._();
  factory DBHelper() => _singleton;
  Database? _database;
  get db async {
    _database ??= await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    var dbDir = await getApplicationDocumentsDirectory();
    var dbPath = path.join(dbDir.path, _databaseName);
    var db = await openDatabase(dbPath, version: _databaseVersion,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE decks(
            id INTEGER PRIMARY KEY,
            name TEXT
          )
        ''');
      await db.execute('''
          CREATE TABLE qcards(
            id INTEGER PRIMARY KEY,
            question TEXT,
            answer TEXT,
            deck_id INTEGER,
            FOREIGN KEY (deck_id) REFERENCES decks(id)
          )
        ''');
    });

    return db;
  }

  Future<List<Map<String, dynamic>>> query(String table,
      {String? where}) async {
    final db = await this.db;
    return where == null ? db.query(table) : db.query(table, where: where);
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await this.db;
    try {
      int id = await db.insert(
        table,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return id;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> update(String table, Map<String, dynamic> data, int id) async {
    final db = await this.db;
    await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteWhere(String table, String column, int value) async {
    final db = await this.db;
    await db.delete(table, where: '$column = ?', whereArgs: [value]);
  }

  Future<void> delete(String table, int id) async {
    final db = await this.db;
    await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
