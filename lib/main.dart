import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/utils/app_theme.dart';

import 'bloc/todo_bloc.dart';
import 'repository/todo_repository.dart';
import 'screens/todo_screen.dart';

/*

  TODO_APP USING BloC, CLOUD FIRESTORE
  AUTHOR: TRUNG DUNG (RYAN) LEE

*/
void main() async {
  //FIREBASE INITIALIZATION

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true, // Enable offline persistence
  );
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => TodoBloc(TodoRepository()),
        child: const TodoScreen(),
      ),
    );
  }
}
