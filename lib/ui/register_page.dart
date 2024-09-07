import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/register/register_bloc.dart';
import '../blocs/register/register_event.dart';
import '../blocs/register/register_state.dart';
import '../utils.dart';
import 'login_page.dart'; // Pastikan halaman login terimport

class RegisterPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? imageBase64; // Variabel untuk gambar dalam format Base64

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Register'),
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
                      // Tampilkan gambar yang di-crop
                      final imageFile = File((state as ImageCroppedState).imagePath);
                      imageBase64 = convertImageToBase64(imageFile); // Konversi ke Base64
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
                      child: CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.add_a_photo, size: 50),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16),
                BlocConsumer<RegisterBloc, RegisterState>(
                  listener: (context, state) {
                    if (state is FormSubmittedState) {
                      // Setelah pendaftaran berhasil, tampilkan dialog verifikasi
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Verifikasi Email'),
                            content: Text(
                                'Registrasi berhasil. Silakan periksa email Anda dan verifikasi sebelum login.'),
                            actions: [
                              TextButton(
                                child: Text('OK'),
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Registration Failed: ${state.error}')),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is FormSubmittingState) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ElevatedButton(
                      onPressed: () {
                        context.read<RegisterBloc>().add(RegisterUserEvent(
                          nameController.text,
                          emailController.text,
                          passwordController.text,
                          imageBase64, // Kirim gambar dalam Base64
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text('Register'),
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
