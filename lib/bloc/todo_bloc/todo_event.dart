import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();
  @override
  List<Object?> get props => [];
}

class AddTodo extends TodoEvent {
  final String title;
  final String subtitle;
  final String? description;
  final String userId;

  const AddTodo({
    required this.title,
    required this.subtitle,
    this.description,
    required this.userId,
  });
  @override
  List<Object?> get props => [title, subtitle, description, userId];
}

class UpdateTodo extends TodoEvent {
  final String title;
  final String docId;
  final String userId;
  final String? subtitle;
  const UpdateTodo({
    required this.title,
    required this.docId,
    required this.subtitle,
    required this.userId,
  });
  @override
  List<Object?> get props => [title, docId, userId, subtitle];
}

class DeleteTodo extends TodoEvent {
  final String userId;
  final String docId;
  const DeleteTodo({required this.userId, required this.docId});
  @override
  List<Object?> get props => [userId, docId];
}

class LoadTodo extends TodoEvent {
  final String userId;
  const LoadTodo({required this.userId});
  @override
  List<Object?> get props => [userId];
}

class ToggleTodo extends TodoEvent {
  final String userId;
  final String docId;
  final bool? toggleTodo;
  const ToggleTodo({
    required this.userId,
    required this.docId,
    required this.toggleTodo,
  });
  @override
  List<Object?> get props => [userId, docId, toggleTodo];
}
