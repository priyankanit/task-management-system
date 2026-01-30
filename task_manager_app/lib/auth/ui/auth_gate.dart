import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../tasks/ui/task_dashboard.dart';
import '../viewmodel/auth_viewmodel.dart';
import 'login_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AuthViewModel>().checkLoginStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (_, authVM, __) {
        if (authVM.isCheckingAuth) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (authVM.isLoggedIn) {
          return const TaskDashboard();
        }
        return const LoginScreen();
      },
    );
  }
}
