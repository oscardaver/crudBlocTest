import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testcrudbloc/presentation/bloc/auth/auth_event.dart';
import 'package:testcrudbloc/presentation/bloc/auth/auth_state.dart';

import '../../../../domain/usecases/auth_usecases.dart';

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