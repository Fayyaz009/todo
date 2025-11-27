part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String userUid;
  const AuthSuccess({required this.userUid});
  @override
  List<Object> get props => [userUid];
}

class EmailLoading extends AuthState {} // New: Email specific

class AnonymousLoading extends AuthState {} // New: Anonymous specific

class AuthError extends AuthState {
  final String errorMessage;
  const AuthError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

class AuthSignOut extends AuthState {}
