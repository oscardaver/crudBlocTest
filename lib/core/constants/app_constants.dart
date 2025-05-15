// Constantes generales de la aplicación
class AppConstants {
  static const String appName = 'NotesApp';
  
  // Database
  static const String dbName = 'notes_app.db';
  static const int dbVersion = 1;
  
  // Tables
  static const String usersTable = 'users';
  static const String notesTable = 'notes';
  
  // Table columns - users
  static const String columnUserId = 'id';
  static const String columnUserEmail = 'email';
  static const String columnUserPassword = 'password';
  static const String columnUserToken = 'token';
  static const String columnUserIsLogged = 'is_logged';
  
  // Table columns - notes
  static const String columnNoteId = 'id';
  static const String columnNoteTitle = 'title';
  static const String columnNoteContent = 'content';
  static const String columnNoteCreatedAt = 'created_at';
  static const String columnNoteUpdatedAt = 'updated_at';
  static const String columnNoteUserId = 'user_id';
  
  // Shared preferences keys
  static const String prefToken = 'user_token';
  static const String prefUserId = 'user_id';
  static const String prefIsLoggedIn = 'is_logged_in';
  
  // Routes
  static const String routeLogin = '/login';
  static const String routeHome = '/home';
  static const String routeCreateNote = '/create-note';
  static const String routeEditNote = '/edit-note';
  
  // Messages
  static const String msgLoginSuccess = 'Inicio de sesión exitoso';
  static const String msgLoginFailed = 'Email o contraseña incorrectos';
  static const String msgLogoutSuccess = 'Sesión cerrada exitosamente';
  static const String msgNoteCreated = 'Nota creada exitosamente';
  static const String msgNoteUpdated = 'Nota actualizada exitosamente';
  static const String msgNoteDeleted = 'Nota eliminada exitosamente';
  static const String msgEmptyFields = 'Por favor, complete todos los campos';
}