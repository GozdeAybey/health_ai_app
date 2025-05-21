import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/health_data_model.dart';

class HealthDatabase {
  static final HealthDatabase instance = HealthDatabase._init();

  static Database? _database;

  HealthDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('health.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE health_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT,
        value REAL,
        date TEXT
      )
    ''');
  }

  Future<void> insertHealthData(HealthDataModel data) async {
    final db = await instance.database;
    await db.insert('health_data', data.toMap());
  }

  Future<List<HealthDataModel>> getAllData() async {
    final db = await instance.database;
    final result = await db.query('health_data');
    return result.map((map) => HealthDataModel.fromMap(map)).toList();
  }
}
