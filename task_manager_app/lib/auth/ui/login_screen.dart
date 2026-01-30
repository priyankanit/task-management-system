import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/auth/ui/register_screen.dart';
import 'package:task_manager_app/auth/viewmodel/auth_viewmodel.dart';
import 'package:task_manager_app/core/widgets/custom_snackbar.dart';
import 'package:task_manager_app/tasks/ui/task_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    return Scaffold(
     body: Padding(padding: const EdgeInsets.all(16),
     child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(labelText: "Email",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.lightBlue, width: 1)
            ),
          prefixIcon: Icon(Icons.email),
          prefixIconColor: Colors.blueGrey,),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.lightBlue, width: 1),
            ),
            prefixIcon: Icon(Icons.person),
            prefixIconColor: Colors.blueGrey,
          ),
          obscureText: true,
        ),
        const SizedBox(height: 20,),
        authVM.isLoading?const CircularProgressIndicator()
        : ElevatedButton(onPressed: () async {
          try {
            await authVM.login(
              emailController.text, 
              passwordController.text
              );
            if(!mounted) return;
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const TaskDashboard(),
            ),
            );
          } catch(e){
            AppSnackBar.show(context, 'Invalid credentials', isError: true);
          }
        }, child: const Text('Login')),
        TextButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=> const RegisterScreen()));
        }, child: const Text('Register'),
        ),
      ],
     ),),
    );
  }

}