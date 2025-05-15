import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testcrudbloc/presentation/bloc/auth/auth_bloc.dart';
import 'package:testcrudbloc/presentation/bloc/auth/auth_event.dart';
import 'package:testcrudbloc/presentation/screens/login/login_screen.dart';
import 'package:testcrudbloc/presentation/screens/note/add_screen.dart';
import 'package:testcrudbloc/presentation/screens/note/edit_screen.dart';

import '../../../domain/entities/user.dart';
import '../../bloc/note/note_bloc.dart';
import '../../bloc/note/note_event.dart';
import '../../bloc/note/note_state.dart';

class NoteScreen extends StatefulWidget {
  final User user;

  const NoteScreen({super.key, required this.user});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NoteBloc>().add(GetNotesEvent(widget.user.id ?? 0));
  }

  void _deleteNote(int noteId) {
    context.read<NoteBloc>().add(DeleteNoteEvent(noteId));
    context.read<NoteBloc>().add(GetNotesEvent(widget.user.id ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Notas'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.user.email),
              accountEmail: Text('Token: ${widget.user.token}'),
              currentAccountPicture: CircleAvatar(
                child: Text(
                  widget.user.email.substring(0, 1).toUpperCase(),
                  style: const TextStyle(fontSize: 24.0),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () {
                context.read<AuthBloc>().add(LogoutEvent());
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<NoteBloc, NoteState>(
                builder: (context, state) {
                  if (state is NoteLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NotesLoadedState) {
                    if (state.notes.isEmpty) {
                      return const Center(child: Text('No hay notas aún.'));
                    }

                    return ListView.separated(
                      itemCount: state.notes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final note = state.notes[index];
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              note.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(note.content),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditScreen(user: widget.user, note: note),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteNote(note.id),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is NoteErrorState) {
                    return Center(child: Text('Error: ${state.message}'));
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddScreen(user: widget.user),
            ),
          );
        },
        label: const Text("Nueva Nota"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
