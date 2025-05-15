import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/note.dart';
import '../../../domain/entities/user.dart';
import '../../bloc/note/note_bloc.dart';
import '../../bloc/note/note_event.dart';
import '../../bloc/note/note_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class AddScreen extends StatefulWidget {
  final User user;

  const AddScreen({super.key, required this.user});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  Note? _editingNote;

  @override
  void initState() {
    super.initState();
    context.read<NoteBloc>().add(GetNotesEvent(widget.user.id ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteBloc, NoteState>(
      listener: (context, state) {
        if (state is NoteCreatedState) {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Nota creada'),
                  content: const Text('La nota se ha creado exitosamente.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Aceptar'),
                    ),
                  ],
                ),
          );
        }

        if (state is NoteErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Notas de ${widget.user.email}')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomTextField(
                controller: _titleController,
                label: 'Título',
                hint: 'Escribe un título',
                icon: Icons.title,
                maxLines: 1,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _contentController,
                label: 'Contenido',
                hint: 'Escribe tu nota',
                icon: Icons.notes,
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              CustomButton(
                label: _editingNote == null ? 'Crear Nota' : 'Actualizar Nota',
                onPressed: _submitNote,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) return;

    if (_editingNote == null) {
      // Crear nueva nota (el ID será generado por el Bloc)
      context.read<NoteBloc>().add(
        CreateNoteEvent(
          title: title,
          content: content,
          userId: widget.user.id ?? 0,
        ),
      );
    } else {
      // Actualizar nota existente
      final updatedNote = _editingNote!.copyWith(
        title: title,
        content: content,
      );
      context.read<NoteBloc>().add(UpdateNoteEvent(updatedNote));
    }

    // Limpiar campos
    _titleController.clear();
    _contentController.clear();
    _editingNote = null;
  }
}
