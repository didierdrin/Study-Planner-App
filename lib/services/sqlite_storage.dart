import 'package:study_planner_app/services/storage_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:study_planner_app/models/task.dart'; 

// SQLite Storage Implementation
class SqliteStorageService implements StorageService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT,
            dueDate INTEGER NOT NULL,
            reminderTime INTEGER,
            notify1DayBefore INTEGER,
            notify1HourBefore INTEGER
          )
        ''');
      },
    );
  }

  @override
  Future<void> saveTasks(List<Task> tasks) async {
    final db = await database;

    // Clear existing tasks
    await db.delete('tasks');

    // Insert all tasks
    for (var task in tasks) {
      await db.insert('tasks', task.toMap());
    }
  }

  @override
  Future<List<Task>> loadTasks() async {
    final db = await database;
    final maps = await db.query('tasks');
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  @override
  Future<void> deleteTask(String id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  @override
  String getStorageType() => 'SQLite Database';
}
