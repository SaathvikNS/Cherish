import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cherish/models/birthday.dart';

class BirthdayDatabase {
  static final BirthdayDatabase instance = BirthdayDatabase._init();

  static Database? _database;

  BirthdayDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('birthdays.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE birthdays (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        day INTEGER NOT NULL,
        month INTEGER NOT NULL,
        year INTEGER,
        age INTEGER,
        relation TEXT,
        reference TEXT,
        whatsapp TEXT,
        email TEXT,
        instagram TEXT,
        remindBefore INTEGER
      )
    ''');
  }

  Future<int> insertBirthday(Birthday birthday) async {
    final db = await instance.database;
    return await db.insert('birthdays', birthday.toMap());
  }

  Future<List<Birthday>> fetchAllBirthdays() async {
    final db = await instance.database;
    final result = await db.query('birthdays');
    return result.map((map) => Birthday.fromMap(map)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
