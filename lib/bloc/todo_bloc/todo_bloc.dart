import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_app/bloc/todo_bloc/todo_event.dart';
import 'package:testing_app/bloc/todo_bloc/todo_state.dart';
import 'package:testing_app/services/firebase_service.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final FirebaseService _services; //

  TodoBloc(this._services) : super(TodoInitial()) {
    on<LoadTodo>(_loadTodo);
    on<AddTodo>(_addTodo);
    on<UpdateTodo>(_updateTodo);
    on<DeleteTodo>(_deleteTodo);
    on<ToggleTodo>(_toggleTodo);
  }

  Future<void> _loadTodo(LoadTodo event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    await emit.forEach<List<Map<String, dynamic>>>(
      _services.loadTodo(event.userId),
      onData: (todos) => TodoLoaded(todos),
      onError: (error, stackTrace) => TodoError(errorMessage: error.toString()),
    );
  }

  Future<void> _addTodo(AddTodo event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      await _services.addTodo(event.userId, event.title);
    } catch (error) {
      emit(TodoError(errorMessage: error.toString()));
    }
  }

  Future<void> _updateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    try {
      await _services.updateTodo(event.userId, event.docId, event.title);
    } catch (error) {
      emit(TodoError(errorMessage: error.toString()));
    }
  }

  Future<void> _deleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    try {
      await _services.deleteTodo(event.userId, event.docId);
    } catch (error) {
      emit(TodoError(errorMessage: error.toString()));
    }
  }

  Future<void> _toggleTodo(ToggleTodo event, Emitter<TodoState> emit) async {
    try {
      await _services.toggleTodo(
        event.userId,
        event.docId,
        event.toggleTodo ?? false,
      );
    } catch (error) {}
  }
}
