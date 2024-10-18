import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:to_do_list/models/page_meta.dart';
import 'package:to_do_list/models/to_do_model.dart';
import 'package:to_do_list/utils/shared_preferences.dart';

class DatabaseHelper {
  DatabaseHelper._internal();

  static final DatabaseHelper _instance = DatabaseHelper._internal();

  static DatabaseHelper get instance => _instance;

  static Database? _database;

  final String _databaseName = 'to_do_app.db';

  // Method to initialize the database
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database?> _initDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, _databaseName);
      String? password = await SharedPreferences.instance.getDatabasePassword();
      if (password == null) {
        password = 'TO_DO_APP_${DateTime.now().microsecondsSinceEpoch}';
        await SharedPreferences.instance.saveDatabasePassword(password);
      }
      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        password: password,
      );
    } catch (e) {
      debugPrint('init database exception: $e');
    }
    return null;
  }

  // Create table schema
  Future _onCreate(Database db, int version) async {
    try {
      await db.execute('''
      CREATE TABLE ${DatabaseTableNames.toDoModel.name} (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       title TEXT,
       isCompleted TEXT
      )
    ''');
    } catch (e) {
      debugPrint('create table exception: $e');
    }
  }

  Future<void> storeToDoTask(ToDoModel toDoModel) async {
    try {
      final db = await database;
      await db.insert(
        DatabaseTableNames.toDoModel.name,
        convertObjectToString(toDoModel.toJson()),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint('storeToDoTask exception: $e');
      rethrow;
    }
  }

  Future<void> updateToDoTask(ToDoModel toDoModel) async {
    try {
      final db = await database;
      await db.update(
        DatabaseTableNames.toDoModel.name,
        convertObjectToString(toDoModel.toJson()),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint('updateToDoTask exception: $e');
      rethrow;
    }
  }

  Future<void> deleteToDoTask(int id) async {
    try {
      final db = await database;
      await db.delete(
        DatabaseTableNames.toDoModel.name,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint('deleteToDoTask exception: $e');
      rethrow;
    }
  }

  Future<List<ToDoModel>> getToDoList(PageMeta pageMeta) async {
    List<ToDoModel> list = [];
    try {
      final db = await database;
      final maps = await db.query(
        DatabaseTableNames.toDoModel.name,
        limit: pageMeta.limit,
        offset: pageMeta.offset,
      );
      if (maps.isNotEmpty) {
        list = List<ToDoModel>.from(
            maps.map((e) => ToDoModel.fromJson(convertStringToObject(e))));
      }
    } catch (e) {
      debugPrint('getToDoList exception: $e');
      rethrow;
    }
    return list;
  }

  Map<String, dynamic> convertObjectToString(Map<String, dynamic> map) {
    return map.map((key, val) {
      return MapEntry(key, val is bool ? '$val' : val);
    });
  }

  Map<String, dynamic> convertStringToObject(Map<String, dynamic> map) {
    return map.map((key, val) {
      return MapEntry(
          key,
          val == 'true'
              ? true
              : val == 'false'
                  ? false
                  : val);
    });
  }
}

enum DatabaseTableNames {
  toDoModel,
}
