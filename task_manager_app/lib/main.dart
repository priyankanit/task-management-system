import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/auth/ui/auth_gate.dart';
import 'package:task_manager_app/auth/viewmodel/auth_viewmodel.dart';
import 'package:task_manager_app/tasks/viewmodel/task_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> AuthViewModel()),
        ChangeNotifierProvider(create: (_)=>TaskViewModel()),
      ],
      child: MaterialApp(
        title: 'Task Management System',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        ),
        home: const AuthGate(),
      ),
    );
  }
}

