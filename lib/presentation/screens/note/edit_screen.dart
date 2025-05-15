import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testcrudbloc/domain/entities/note.dart';
import 'package:testcrudbloc/domain/entities/user.dart';
import 'package:testcrudbloc/presentation/bloc/note/note_bloc.dart';
import 'package:testcrudbloc/presentation/bloc/note/note_event.dart';
import 'package:testcrudbloc/presentation/screens/widgets/custom_button.dart';

class EditScreen extends StatefulWidget {
  final User user;
  final Note note;

  const EditScreen({super.key, required this.user, required this.note});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      final updatedNote = Note(
        id: widget.note.id,
        userId: widget.user.id!,
        title: _titleController.text,
        content: _contentController.text,
      );

      context.read<NoteBloc>().add(UpdateNoteEvent(updatedNote));
      context.read<NoteBloc>().add(GetNotesEvent(widget.user.id!));

      Navigator.pop(context); // Regresar a NoteScreen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Nota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) => value == null || value.isEmpty ? 'Título requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Contenido'),
                maxLines: 5,
                validator: (value) => value == null || value.isEmpty ? 'Contenido requerido' : null,
              ),
              const SizedBox(height: 24),
              CustomButton(
                onPressed: _saveNote,
                label: "Guardar Cambios",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
