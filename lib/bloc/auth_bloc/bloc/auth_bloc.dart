import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_app/services/firebase_service.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseService _services;
  AuthBloc() : _services = FirebaseService(), super(AuthInitial()) {
    on<AuthSignInAnonymouslyButton>(_authSignInAnonymouslyButton);
    on<SignOutButtonClicked>(_signOutButtonClicked);
    on<AuthSigninWithEmailAndPasswordButton>(
      _authSignInWithEmailAndPasswordButton,
    );
  }

  Future<void> _authSignInAnonymouslyButton(
    AuthSignInAnonymouslyButton event,
    Emitter<AuthState> emit,
  ) async {
    emit(AnonymousLoading()); // Changed: Specific loading
    try {
      final String id = await _services.authSignIn();
      emit(AuthSuccess(userUid: id));
    } catch (error) {
      emit(AuthError(errorMessage: error.toString()));
    }
  }

  Future<void> _signOutButtonClicked(
    SignOutButtonClicked event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading()); // SignOut pe general loading theek
    try {
      await _services.authSignOut();
      emit(AuthSignOut());
    } catch (error) {
      emit(AuthError(errorMessage: error.toString()));
    }
  }

  Future<void> _authSignInWithEmailAndPasswordButton(
    AuthSigninWithEmailAndPasswordButton event,
    Emitter<AuthState> emit,
  ) async {
    emit(EmailLoading()); // Changed: Specific loading
    try {
      String id = await _services.authSignInwithEmailAndPassword(
        event.email,
        event.password,
      );
      emit(AuthSuccess(userUid: id));
    } catch (e) {
      emit(AuthError(errorMessage: e.toString()));
    }
  }
}
