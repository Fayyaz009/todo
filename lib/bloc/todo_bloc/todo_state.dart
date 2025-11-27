import 'package:equatable/equatable.dart';

abstract class TodoState extends Equatable {
  const TodoState();
  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Map<String, dynamic>> todos;
  const TodoLoaded(this.todos);
  @override
  List<Object?> get props => [todos];
}

class TodoDeleted extends TodoState {}

class TodoUpdated extends TodoState {}

class TodoError extends TodoState {
  final String errorMessage;
  const TodoError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class TodoToggle extends TodoState {}
