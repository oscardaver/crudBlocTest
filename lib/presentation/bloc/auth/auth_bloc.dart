import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/user.dart';
import '../../../../domain/usecases/auth_usecases.dart';

// Eventos
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;

  const RegisterEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LogoutEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}

// Estados
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthenticatedState extends AuthState {
  final User user;

  const AuthenticatedState(this.user);

  @override
  List<Object?> get props => [user];
}

class UnauthenticatedState extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final RegisterUserUseCase registerUserUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.registerUserUseCase,
    required this.checkAuthStatusUseCase,
  }) : super(AuthInitialState()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<RegisterEvent>(_onRegister);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());

      final user = await registerUserUseCase(event.email, event.password);
      emit(AuthenticatedState(user));
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      
      final user = await loginUseCase(event.email, event.password);
      
      if (user != null) {
        emit(AuthenticatedState(user));
      } else {
        emit(const AuthErrorState('Credenciales inválidas'));
      }
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      
      await logoutUseCase();
      
      emit(UnauthenticatedState());
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      
      final user = await checkAuthStatusUseCase();
      
      if (user != null) {
        emit(AuthenticatedState(user));
      } else {
        emit(UnauthenticatedState());
      }
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }
}