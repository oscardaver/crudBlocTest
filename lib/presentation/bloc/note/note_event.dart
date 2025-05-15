import 'package:equatable/equatable.dart';

import '../../../domain/entities/note.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();
  @override
  List<Object?> get props => [];
}

class GetNotesEvent extends NoteEvent {
  final int userId;
  const GetNotesEvent(this.userId);
  @override
  List<Object?> get props => [userId];
}



class CreateNoteEvent extends NoteEvent {
  final int? id; // Opcional
  final String title;
  final String content;
  final int userId;

  const CreateNoteEvent({
    this.id,
    required this.title,
    required this.content,
    required this.userId,
  });

  @override
  List<Object?> get props => [id, title, content, userId];
}

class UpdateNoteEvent extends NoteEvent {
  final Note note;
  const UpdateNoteEvent(this.note);
  @override
  List<Object?> get props => [note];
}

class DeleteNoteEvent extends NoteEvent {
  final int noteId;
  const DeleteNoteEvent(this.noteId);
  @override
  List<Object?> get props => [noteId];
}
