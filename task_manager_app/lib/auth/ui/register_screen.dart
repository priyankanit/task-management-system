import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/auth/ui/login_screen.dart';
import 'package:task_manager_app/auth/viewmodel/auth_viewmodel.dart';
import 'package:task_manager_app/core/widgets/custom_dialog.dart';
import 'package:task_manager_app/core/widgets/custom_snackbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authVM = context.read<AuthViewModel>();
    return Scaffold(
      body: Padding(padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.lightBlue, width: 1)
            ),
            prefixIcon: Icon(Icons.email),
            prefixIconColor: Colors.blueGrey,
            ),
            
          ),
          const SizedBox(height:10),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
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
          ElevatedButton(onPressed: () async {
            try{
             await authVM.register(emailController.text, passwordController.text);

             if(!mounted) return;
             AppDialog.show(context, 
             title: 'Success', message: 'Registration completed successfully. Please login.',
             );
          } catch (e){
            AppSnackBar.show(context,'Registration Failed' );
          }
          },
            
            child: Text('Register')),
            TextButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=> const LoginScreen()));
        }, child: const Text('Login'),
        ),
        ],
      ),),
    );
  }
}