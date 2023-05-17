import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/todo_model.dart';

class TodoRepository {
  final CollectionReference _todosCollection =
      FirebaseFirestore.instance.collection('todos');

  Future<List<Todo>> getTodos() async {
    final snapshot = await _todosCollection.get();
    return snapshot.docs.map((doc) => Todo.fromSnapshot(doc)).toList();
  }

  Future<void> addTodo(Todo todo) {
    return _todosCollection.add(todo.toMap());
  }

  Future<void> updateTodo(Todo todo) {
    return _todosCollection.doc(todo.id).update(todo.toMap());
  }

  Future<void> deleteTodo(Todo todo) {
    return _todosCollection.doc(todo.id).delete();
  }
}
