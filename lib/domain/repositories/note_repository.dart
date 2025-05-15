import '../entities/note.dart';

abstract class NoteRepository {
  // Obtener todas las notas de un usuario
  Future<List<Note>> getNotes(int userId);
  
  // Obtener una nota por su ID
  Future<Note?> getNoteById(int id);
  
  // Crear una nueva nota
  Future<Note> createNote(Note note);
  
  // Actualizar una nota existente
  Future<Note> updateNote(Note note);
  
  // Eliminar una nota
  Future<bool> deleteNote(int id);
}