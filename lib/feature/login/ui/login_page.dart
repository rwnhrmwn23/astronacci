import 'package:astronacci/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../forgot_password/ui/forgot_password_page.dart';
import '../../home/ui/home_page.dart';
import '../blocs/login_bloc.dart';
import '../blocs/login_event.dart';
import '../blocs/login_state.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      // Navigate to Register page
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.blue, // Link-style color
                        decoration: TextDecoration.underline, // Underline text
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoginSuccessState) {
                    // Navigasi ke HomePage setelah login berhasil
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const HomePage()),
                          (Route<dynamic> route) => false,
                    );
                  } else if (state is LoginFailedState) {
                    showSnackBar(context, 'Login Failed: ${state.error}');
                  }
                },
                builder: (context, state) {
                  if (state is LoginSubmittingState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    onPressed: () {
                      context.read<LoginBloc>().add(
                        LoginUserEvent(
                          emailController.text,
                          passwordController.text,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Login'),
                  );
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                  );
                },
                child: const Text(
                  "Forgot password?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
