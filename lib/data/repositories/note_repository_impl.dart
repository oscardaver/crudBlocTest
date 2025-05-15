import 'package:sqflite/sqflite.dart';
import 'package:testcrudbloc/data/datasources/local/database_helper.dart';

import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/note.dart';
import '../../../domain/repositories/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final DatabaseHelper _databaseHelper;

  NoteRepositoryImpl(this._databaseHelper);

  @override
  Future<List<Note>> getNotes(int userId) async {
    final db = await _databaseHelper.database;
    final results = await db.query(
      AppConstants.notesTable,
      where: '${AppConstants.columnNoteUserId} = ?',
      whereArgs: [userId],
      orderBy: '${AppConstants.columnNoteUpdatedAt} DESC',
    );
    return results.map((map) => Note.fromMap(map)).toList();
  }

  @override
  Future<Note?> getNoteById(int id) async {
    final db = await _databaseHelper.database;
    final results = await db.query(
      AppConstants.notesTable,
      where: '${AppConstants.columnNoteId} = ?',
      whereArgs: [id],
    );
    return results.isEmpty ? null : Note.fromMap(results.first);
  }

  @override
  Future<bool> doesIdExist(int id) async {
    final db = await _databaseHelper.database;
    final result = await db.query(
      AppConstants.notesTable,
      where: '${AppConstants.columnNoteId} = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }

  @override
  Future<Note> createNote(Note note) async {
    if (note.id == null) {
      throw Exception('Note ID cannot be null for non-autoincrement tables');
    }

    final db = await _databaseHelper.database;
    
    // Verificar si el ID ya existe
    if (await doesIdExist(note.id!)) {
      throw Exception('Note with ID ${note.id} already exists');
    }

    await db.insert(
      AppConstants.notesTable,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return note;
  }

  @override
  Future<Note> updateNote(Note note) async {
    if (note.id == null) {
      throw Exception('Note ID cannot be null for updates');
    }

    final db = await _databaseHelper.database;
    await db.update(
      AppConstants.notesTable,
      note.toMap(),
      where: '${AppConstants.columnNoteId} = ?',
      whereArgs: [note.id],
    );
    return note;
  }

  @override
  Future<bool> deleteNote(int id) async {
    final db = await _databaseHelper.database;
    final result = await db.delete(
      AppConstants.notesTable,
      where: '${AppConstants.columnNoteId} = ?',
      whereArgs: [id],
    );
    return result > 0;
  }
}