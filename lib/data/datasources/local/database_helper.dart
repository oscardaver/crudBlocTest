import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/constants/app_constants.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), AppConstants.dbName);
    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Crear tabla de usuarios
    await db.execute('''
      CREATE TABLE ${AppConstants.usersTable} (
        ${AppConstants.columnUserId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${AppConstants.columnUserEmail} TEXT NOT NULL UNIQUE,
        ${AppConstants.columnUserPassword} TEXT NOT NULL,
        ${AppConstants.columnUserToken} TEXT,
        ${AppConstants.columnUserIsLogged} INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Crear tabla de notas
    await db.execute('''
      CREATE TABLE ${AppConstants.notesTable} (
        ${AppConstants.columnNoteId} INTEGER PRIMARY KEY,
        ${AppConstants.columnNoteTitle} TEXT NOT NULL,
        ${AppConstants.columnNoteContent} TEXT NOT NULL,
        ${AppConstants.columnNoteCreatedAt} TEXT NOT NULL,
        ${AppConstants.columnNoteUpdatedAt} TEXT NOT NULL,
        ${AppConstants.columnNoteUserId} INTEGER NOT NULL,
        FOREIGN KEY (${AppConstants.columnNoteUserId}) 
          REFERENCES ${AppConstants.usersTable} (${AppConstants.columnUserId})
          ON DELETE CASCADE
      )
    ''');


  }

 // Método para eliminar la base de datos
  Future<void> clearDatabase() async {
    final path = join(await getDatabasesPath(), AppConstants.dbName);
    await deleteDatabase(path); // Elimina la base de datos usando sqflite.deleteDatabase()
  }
}