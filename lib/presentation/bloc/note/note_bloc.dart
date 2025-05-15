import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/note_usecases.dart';
import 'note_event.dart';
import 'note_state.dart';

// Eventos

// Estados

// BLoC
class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final GetNotesUseCase getNotes;
  final CreateNoteUseCase createNote;
  final UpdateNoteUseCase updateNote;
  final DeleteNoteUseCase deleteNote;

  NoteBloc({
    required this.getNotes,
    required this.createNote,
    required this.updateNote,
    required this.deleteNote,
  }) : super(NoteInitialState( )) {
    on<GetNotesEvent>(_onGetNotes);
    on<CreateNoteEvent>(_onCreateNote);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<DeleteNoteEvent>(_onDeleteNote);
  }

  Future<void> _onGetNotes(GetNotesEvent event, Emitter<NoteState> emit) async {
    try {
      emit(NoteLoadingState());
      final notes = await getNotes(event.userId);
      emit(NotesLoadedState(notes));
    } catch (e) {
      emit(NoteErrorState('Error al obtener notas: ${e.toString()}'));
    }
  }

  // En tu NoteBloc, modifica el manejador de _onCreateNote
Future<void> _onCreateNote(
  CreateNoteEvent event,
  Emitter<NoteState> emit,
) async {
  try {
    emit(NoteLoadingState());

    await createNote(
      title: event.title,
      content: event.content,
      userId: event.userId,
    );

    emit(NoteCreatedState());

    final notes = await getNotes(event.userId);
    emit(NotesLoadedState(notes));
  } catch (e) {
    emit(NoteErrorState('Error al crear nota: ${e.toString()}'));
    emit(NotesLoadedState([])); 
  }
}

  Future<void> _onUpdateNote(
    UpdateNoteEvent event,
    Emitter<NoteState> emit,
  ) async {
    try {
      emit(NoteLoadingState());
      await updateNote(event.note);
      final notes = await getNotes(event.note.userId);
      emit(NotesLoadedState(notes));
    } catch (e) {
      emit(NoteErrorState('Error al actualizar nota: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteNote(
    DeleteNoteEvent event,
    Emitter<NoteState> emit,
  ) async {
    try {
      emit(NoteLoadingState());
      await deleteNote(event.noteId);

      final currentState = state;
      if (currentState is NotesLoadedState && currentState.notes.isNotEmpty) {
        final userId = currentState.notes.first.userId;
        final notes = await getNotes(userId);
        emit(NotesLoadedState(notes));
      }
    } catch (e) {
      emit(NoteErrorState('Error al eliminar nota: ${e.toString()}'));
    }
  }
}
