import '../entities/user.dart';

abstract class AuthRepository {
  // Registrar un nuevo usuario
  Future<User> registerUser(String email, String password);
  
  // Iniciar sesión con email y contraseña
  Future<User?> login(String email, String password);
  
  // Cerrar sesión
  Future<void> logout();
  
  // Verificar el estado de autenticación
  Future<User?> checkAuthStatus();
  
  // Generar un nuevo token
  String generateToken();
}