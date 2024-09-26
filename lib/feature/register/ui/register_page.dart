import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/utils.dart';
import '../../login/ui/login_page.dart';
import '../blocs/register_bloc.dart';
import '../blocs/register_event.dart';
import '../blocs/register_state.dart';

class RegisterPage extends StatefulWidget {

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  String? imageBase64;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocBuilder<RegisterBloc, RegisterState>(
                  builder: (context, state) {
                    if (state is ImageCroppedState) {
                      final imageFile = File((state).imagePath);
                      imageBase64 = convertImageToBase64(imageFile);
                      return GestureDetector(
                        onTap: () {
                          context.read<RegisterBloc>().add(PickImageEvent());
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(File(state.imagePath)),
                        ),
                      );
                    }
                    return GestureDetector(
                      onTap: () {
                        context.read<RegisterBloc>().add(PickImageEvent());
                      },
                      child: const CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.add_a_photo, size: 50),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
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
                BlocConsumer<RegisterBloc, RegisterState>(
                  listener: (context, state) {
                    if (state is FormSubmittedState) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Verifikasi Email'),
                            content: const Text(
                                'Registrasi berhasil. Silakan periksa email Anda dan verifikasi sebelum login.'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(), // Arahkan ke halaman login
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                    if (state is FormSubmissionFailedState) {
                      showSnackBar(context, 'Registration Failed: ${state.error}');
                    }
                  },
                  builder: (context, state) {
                    if (state is FormSubmittingState) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ElevatedButton(
                      onPressed: () {
                        context.read<RegisterBloc>().add(RegisterUserEvent(
                          nameController.text,
                          emailController.text,
                          passwordController.text,
                          imageBase64,
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Register'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
