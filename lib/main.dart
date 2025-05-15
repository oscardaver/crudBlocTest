import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testcrudbloc/presentation/bloc/auth/auth_event.dart';

// Core
import 'core/constants/app_constants.dart';
import 'core/themes/app_theme.dart';
// Data
import 'data/datasources/local/database_helper.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/note_repository_impl.dart';
// Domain
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/note_repository.dart';
import 'domain/usecases/auth_usecases.dart';
import 'domain/usecases/note_usecases.dart';
// Presentation
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/note/note_bloc.dart';
import 'presentation/screens/login/login_screen.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the database
  final databaseHelper = DatabaseHelper();
  await databaseHelper.initDatabase();
  
  // Run the app
  runApp(MyApp(databaseHelper: databaseHelper));
}

class MyApp extends StatelessWidget {
  final DatabaseHelper databaseHelper;
  
  const MyApp({Key? key, required this.databaseHelper}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // Repositories
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(databaseHelper),
        ),
        RepositoryProvider<NoteRepository>(
          create: (context) => NoteRepositoryImpl(databaseHelper),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // BLoCs
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              loginUseCase: LoginUseCase(context.read<AuthRepository>()),
              logoutUseCase: LogoutUseCase(context.read<AuthRepository>()),
              checkAuthStatusUseCase: CheckAuthStatusUseCase(context.read<AuthRepository>()),             
              registerUserUseCase: RegisterUserUseCase(context.read<AuthRepository>()), // Aquí inyectamos el RegisterUserUseCase

            )..add(CheckAuthStatusEvent()),
          ),
          BlocProvider<NoteBloc>(
            create: (context) => NoteBloc(
              getNotes: GetNotesUseCase(context.read<NoteRepository>()),
              createNote: CreateNoteUseCase(context.read<NoteRepository>()),
              updateNote: UpdateNoteUseCase(context.read<NoteRepository>()),
              deleteNote: DeleteNoteUseCase(context.read<NoteRepository>()),
            ),
          ),
        ],
        child: MaterialApp(
          title: AppConstants.appName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          home: const LoginScreen(),
        ),
      ),
    );
  }
}