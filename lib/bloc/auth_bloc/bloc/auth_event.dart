part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthSignInAnonymouslyButton extends AuthEvent {}

class AuthSigninWithEmailAndPasswordButton extends AuthEvent {
  final String email;
  final String password;
  const AuthSigninWithEmailAndPasswordButton({
    required this.email,
    required this.password,
  });
  @override
  List<Object> get props => [email, password];
}

class SignOutButtonClicked extends AuthEvent {}
