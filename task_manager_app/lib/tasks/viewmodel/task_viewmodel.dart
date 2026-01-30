import 'package:flutter/material.dart';

import '../repository/task_repository.dart';

class TaskViewModel extends ChangeNotifier {
  final _repo = TaskRepository();

  List tasks = [];
  bool isLoading = false;
  String? statusFilter; 
  String searchQuery = '';


  Future<void> loadTasks() async {
    try{
    isLoading = true;
    notifyListeners();

    tasks = await _repo.fetchTasks(
      status: statusFilter,
      search: searchQuery,
    );
    } finally {
    isLoading = false;
    notifyListeners();
  }
  }

  Future<void> createTask(String title) async {
    if (title.trim().isEmpty) {
      throw Exception('Title required');
    }

    await _repo.createTask(title);
    await loadTasks();
  }

  Future<void> toggleTask(int id) async {
    await _repo.toggleTask(id);
    await loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await _repo.deleteTask(id);
    tasks.removeWhere((t) => t['id'] == id);
    notifyListeners();
  }

  Future<void> updateTask(int id, String title) async {
    if (title.trim().isEmpty) {
      throw Exception('Title required');
    }

    await _repo.updateTask(id, title);
    await loadTasks();
  }
}
