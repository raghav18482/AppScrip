import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/todo_model.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'todos.db');
    return await openDatabase(
      path,
      version: 2, // Increase the version number for migration
      onCreate: (db, version) {
        return db.execute(
            '''
        CREATE TABLE todos (
          id INTEGER PRIMARY KEY, 
          userId INTEGER, 
          title TEXT, 
          completed INTEGER,
          priority TEXT DEFAULT 'low', 
          inProgress INTEGER DEFAULT 0
        )
        '''
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute("ALTER TABLE todos ADD COLUMN priority TEXT DEFAULT 'low'");
          db.execute("ALTER TABLE todos ADD COLUMN inProgress INTEGER DEFAULT 0");
        }
      },
    );
  }

  Future<void> insertTodos(List<TodoModel> todos) async {
    final db = await database;
    Batch batch = db.batch();
    for (var todo in todos) {
      batch.insert(
        'todos',
        {
          ...todo.toMap(),
          'priority': todo.priority ?? 'low',
          'inProgress': todo.inProgress ? 1 : 0
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }


  Future<List<TodoModel>> fetchTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      // limit: limit,
      // offset: offset,
    );
    return List.generate(maps.length, (i) => TodoModel.fromMap(maps[i]));
  }

  Future<void> deleteTodo(int id) async {
    final db = await database;
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateTodo(int id, {String? title, bool? completed, bool? inProgress, String? priority}) async {
    final db = await database;
    await db.update(
      'todos',
      {
        if (title != null) 'title': title,
        if (completed != null) 'completed': completed ? 1 : 0,
        if (inProgress != null) 'inProgress': inProgress ? 1 : 0,
        if (priority != null) 'priority': priority,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// **🔹 Fetch all tasks where `inProgress` is false and `completed` is false**
  Future<List<TodoModel>> getPendingTodos(int limit, int offset) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'inProgress = ? AND completed = ?',
      whereArgs: [0, 0], // 0 means false in SQLite
      limit: limit,
      offset: offset,
    );

    return List.generate(maps.length, (i) {
      return TodoModel.fromMap(maps[i]);
    });
  }


  Future<List<TodoModel>> getInProgressTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'inProgress = ?',
      whereArgs: [1], // 1 means true in SQLite
    );

    return List.generate(maps.length, (i) {
      return TodoModel.fromMap(maps[i]);
    });
  }

  Future<List<TodoModel>> getCompletedTasks(int limit, int offset) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'completed = ?',
      whereArgs: [1], // 1 means true in SQLite
      limit: limit,
      offset: offset,
    );

    return List.generate(maps.length, (i) {
      return TodoModel.fromMap(maps[i]);
    });
  }


}
