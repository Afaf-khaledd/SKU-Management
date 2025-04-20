import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/authRepo.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.loginWithEmail(event.email, event.password).then((user) {
        emit(AuthSuccess(user!));
      });
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
  Future<void> _onRegisterRequested(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.signup(event.email, event.password).then((user) {
        emit(AuthSuccess(user!));
      });
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onResetPasswordRequested(
      ResetPasswordRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.resetPassword(event.email);
      emit(AuthResetSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.logout();
      emit(LogoutSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}