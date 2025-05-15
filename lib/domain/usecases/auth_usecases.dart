import '../entities/user.dart';
import '../repositories/auth_repository.dart';

// Caso de uso para registrar un usuario
class RegisterUserUseCase {
  final AuthRepository repository;

  RegisterUserUseCase(this.repository);

  Future<User> call(String email, String password) {
    return repository.registerUser(email, password);
  }
}

// Caso de uso para iniciar sesión
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User?> call(String email, String password) {
    return repository.login(email, password);
  }
}

// Caso de uso para cerrar sesión
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}

// Caso de uso para verificar el estado de autenticación
class CheckAuthStatusUseCase {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  Future<User?> call() {
    return repository.checkAuthStatus();
  }
}