import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/todo_model.dart';
import '../repository/todo_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;

  TodoBloc(this.repository) : super(TodoInitial()) {
    on<LoadTodos>((event, emit) async {
      emit(TodoLoading());
      try {
        final todos = await repository.getTodos();
        emit(TodoLoaded(todos));
      } catch (e) {
        emit(const TodoError('Failed to load todos'));
      }
    });

    on<AddTodo>((event, emit) async {
      if (state is TodoLoaded) {
        final List<Todo> updatedTodos = List.from((state as TodoLoaded).todos)
          ..add(event.todo);
        emit(TodoLoaded(updatedTodos));
        try {
          await repository.addTodo(event.todo);
        } catch (e) {
          emit(const TodoError('Failed to add todo'));
        }
      }
    });

    on<UpdateTodo>((event, emit) async {
      if (state is TodoLoaded) {
        final List<Todo> updatedTodos = (state as TodoLoaded).todos.map((todo) {
          return todo.id == event.todo.id ? event.todo : todo;
        }).toList();
        emit(TodoLoaded(updatedTodos));
        try {
          await repository.updateTodo(event.todo);
        } catch (e) {
          emit(const TodoError('Failed to update todo'));
        }
      }
    });

    on<DeleteTodo>((event, emit) async {
      if (state is TodoLoaded) {
        final List<Todo> updatedTodos = (state as TodoLoaded)
            .todos
            .where((todo) => todo.id != event.todo.id)
            .toList();
        emit(TodoLoaded(updatedTodos));
        try {
          await repository.deleteTodo(event.todo);
        } catch (e) {
          emit(const TodoError('Failed to delete todo'));
        }
      }
    });
  }

  Stream<TodoState> mapEventToState(
    TodoEvent event,
  ) async* {
    if (event is LoadTodos) {
      yield* _mapLoadTodosToState();
    } else if (event is AddTodo) {
      yield* _mapAddTodoToState(event);
    } else if (event is UpdateTodo) {
      yield* _mapUpdateTodoToState(event);
    } else if (event is DeleteTodo) {
      yield* _mapDeleteTodoToState(event);
    }
  }

  Stream<TodoState> _mapLoadTodosToState() async* {
    yield TodoLoading();
    try {
      final todos = await repository.getTodos();
      yield TodoLoaded(todos);
    } catch (e) {
      yield const TodoError('Failed to load todos');
    }
  }

  Stream<TodoState> _mapAddTodoToState(AddTodo event) async* {
    if (state is TodoLoaded) {
      final List<Todo> updatedTodos = List.from((state as TodoLoaded).todos)
        ..add(event.todo);
      yield TodoLoaded(updatedTodos);
      repository.addTodo(event.todo);
    }
  }

  Stream<TodoState> _mapUpdateTodoToState(UpdateTodo event) async* {
    if (state is TodoLoaded) {
      final List<Todo> updatedTodos = (state as TodoLoaded).todos.map((todo) {
        return todo.id == event.todo.id ? event.todo : todo;
      }).toList();
      yield TodoLoaded(updatedTodos);
      repository.updateTodo(event.todo);
    }
  }

  Stream<TodoState> _mapDeleteTodoToState(DeleteTodo event) async* {
    if (state is TodoLoaded) {
      final List<Todo> updatedTodos = (state as TodoLoaded)
          .todos
          .where((todo) => todo.id != event.todo.id)
          .toList();
      yield TodoLoaded(updatedTodos);
      repository.deleteTodo(event.todo);
    }
  }
}
