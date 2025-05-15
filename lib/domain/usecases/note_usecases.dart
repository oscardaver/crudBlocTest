import '../entities/note.dart';
import '../repositories/note_repository.dart';

class GetNotesUseCase {
  final NoteRepository repository;

  GetNotesUseCase(this.repository);

  Future<List<Note>> call(int userId) {
    return repository.getNotes(userId);
  }
}

class GetNoteByIdUseCase {
  final NoteRepository repository;

  GetNoteByIdUseCase(this.repository);

  Future<Note?> call(int id) {
    return repository.getNoteById(id);
  }
}

class CreateNoteUseCase {
  final NoteRepository repository;
  final IdGenerator idGenerator; // Nueva dependencia

  CreateNoteUseCase(this.repository, {IdGenerator? idGenerator})
      : idGenerator = idGenerator ?? IdGenerator();

  Future<Note> call({
    int? id, // Opcional (si no se provee, se genera)
    required String title,
    required String content,
    required int userId,
  }) async {
    final noteId = id ?? await idGenerator.generateId();
    
    final note = Note(
      id: noteId,
      title: title,
      content: content,
      userId: userId,
    );
    
    return repository.createNote(note);
  }
}

class UpdateNoteUseCase {
  final NoteRepository repository;

  UpdateNoteUseCase(this.repository);

  Future<Note> call(Note note) {
    return repository.updateNote(note);
  }
}

class DeleteNoteUseCase {
  final NoteRepository repository;

  DeleteNoteUseCase(this.repository);

  Future<bool> call(int id) {
    return repository.deleteNote(id);
  }
}

// Clase auxiliar para generación de IDs
class IdGenerator {
  Future<int> generateId() async {
    // Implementación básica usando timestamp
    return DateTime.now().millisecondsSinceEpoch;
    
    // Alternativa con UUID:
    // return Uuid().v4().hashCode.abs();
  }
}