import 'package:equatable/equatable.dart' show Equatable;

import '../../../domain/entities/note.dart';

abstract class NoteState extends Equatable {
  const NoteState();
  @override
  List<Object?> get props => [];
}

class NoteInitialState extends NoteState {}

class NoteLoadingState extends NoteState {}

class NotesLoadedState extends NoteState {
  final List<Note> notes;
  const NotesLoadedState(this.notes);
  @override
  List<Object?> get props => [notes];
}
class NoteCreatedState extends NoteState {}


class NoteOperationSuccessState extends NoteState {
  final String message;
  const NoteOperationSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}

class NoteErrorState extends NoteState {
  final String message;
  const NoteErrorState(this.message);
  @override
  List<Object?> get props => [message];
}