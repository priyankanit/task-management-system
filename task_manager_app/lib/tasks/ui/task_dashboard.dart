import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/auth/ui/login_screen.dart';
import 'package:task_manager_app/auth/viewmodel/auth_viewmodel.dart';
import 'package:task_manager_app/core/widgets/custom_dialog.dart';
import 'package:task_manager_app/core/widgets/custom_snackbar.dart';
import 'package:task_manager_app/tasks/viewmodel/task_viewmodel.dart';

class TaskDashboard extends StatefulWidget {
  const TaskDashboard({super.key});

  @override
  State<TaskDashboard> createState() => _TaskDashboardState();
}

class _TaskDashboardState extends State<TaskDashboard> {
  final taskCtrl = TextEditingController();
  final searchCtrl = TextEditingController();
  Timer? _debounce;
  final FocusNode _filterFocusNode = FocusNode(canRequestFocus: false);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TaskViewModel>().loadTasks();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchCtrl.dispose();
    taskCtrl.dispose();
    _filterFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final taskVM = context.watch<TaskViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Dashboard'),
        actions: [
          Consumer<TaskViewModel>(
            builder: (_, taskVM, __) {
              return Focus(
                focusNode: _filterFocusNode,
                child: DropdownButton<String>(
                  value: taskVM.statusFilter,
                  hint: const Text('Filter'),
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('All')),
                    DropdownMenuItem(value: 'true', child: Text('Completed')),
                    DropdownMenuItem(value: 'false', child: Text('Pending')),
                  ],
                  onChanged: (value) {
                    taskVM.statusFilter = value;
                    taskVM.loadTasks();
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AppDialog.show(
                context,
                title: 'Logout',
                message: 'Are you sure you want to logout?',
                buttonText: 'Logout',
                onPressed: () async {
                  await context.read<AuthViewModel>().logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (_) => false,
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Consumer<TaskViewModel>(
        builder: (_, taskVM, __) {
          if (taskVM.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              // 🔍 SEARCH BAR
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: searchCtrl,
                  autofocus: false,
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    hintText: 'Search tasks...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _debounce?.cancel();
                    _debounce = Timer(const Duration(milliseconds: 800), () {
                      taskVM.searchQuery = value;
                      taskVM.loadTasks();
                    });
                  },
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => taskVM.loadTasks(),
                  child: ListView.builder(
                    itemCount: taskVM.tasks.length,
                    itemBuilder: (_, index) {
                      final task = taskVM.tasks[index];
                      return ListTile(
                        title: Text(task['title']),
                        leading: Checkbox(
                          value: task['status'],
                          onChanged: (_) async {
                            try {
                              await taskVM.toggleTask(task['id']);
                            } catch (_) {
                              AppSnackBar.show(
                                context,
                                'Failed to update task',
                                isError: true,
                              );
                            }
                          },
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed:
                                  () => _showEditTaskDialog(
                                    context,
                                    task['id'],
                                    task['title'],
                                  ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed:
                                  () => _confirmDelete(context, task['id']),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    taskCtrl.clear();
    AppDialog.show(
      context,
      title: 'Add Task',
      message: '',
      customContent: TextField(
        controller: taskCtrl,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Task title'),
      ),
      buttonText: 'Add',
      onPressed: () async {
        if (taskCtrl.text.trim().isEmpty) {
          AppSnackBar.show(
            context,
            'Task title cannot be empty',
            isError: true,
          );
          return;
        }
        try {
          final vm = context.read<TaskViewModel>();

          await vm.createTask(taskCtrl.text.trim());

          // ✅ RESET filters so new task is visible
          vm.searchQuery = '';
          vm.statusFilter = null;
          await vm.loadTasks();
          //await context.read<TaskViewModel>().createTask(taskCtrl.text.trim());
          Navigator.pop(context);
          AppSnackBar.show(context, 'Task added');
        } catch (_) {
          AppSnackBar.show(context, 'Failed to add task', isError: true);
        }
      },
    );
  }

  void _showEditTaskDialog(BuildContext context, int id, String currentTitle) {
    taskCtrl.text = currentTitle;

    AppDialog.show(
      context,
      title: 'Edit Task',
      message: '',
      customContent: TextField(
        controller: taskCtrl,
        decoration: const InputDecoration(hintText: 'Task title'),
      ),
      buttonText: 'Update',
      onPressed: () async {
        try {
          await context.read<TaskViewModel>().updateTask(id, taskCtrl.text);
          Navigator.pop(context);
          AppSnackBar.show(context, 'Task updated');
        } catch (_) {
          AppSnackBar.show(context, 'Failed to update task', isError: true);
        }
      },
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    AppDialog.show(
      context,
      title: 'Delete Task',
      message: 'Are you sure you want to delete this task?',
      buttonText: 'Delete',
      onPressed: () async {
        try {
          await context.read<TaskViewModel>().deleteTask(id);
          Navigator.pop(context);
          AppSnackBar.show(context, 'Task deleted');
        } catch (_) {
          AppSnackBar.show(context, 'Failed to delete task', isError: true);
        }
      },
    );
  }
}
