import 'package:astronacci/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../login/ui/login_page.dart';
import '../blocs/forgot_password_bloc.dart';
import '../blocs/forgot_password_event.dart';
import '../blocs/forgot_password_state.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Forgot Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
                listener: (context, state) {
                  if (state is ForgotPasswordSuccessState) {
                    // Tampilkan dialog setelah tautan reset password berhasil dikirim
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Tautan Reset Terkirim'),
                          content: Text(
                            'Tautan reset kata sandi telah dikirim ke ${emailController.text}. '
                            'Periksa email Anda dan ikuti instruksi untuk mereset kata sandi.',
                          ),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Tutup dialog
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        LoginPage(), // Arahkan ke halaman login
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else if (state is ForgotPasswordFailedState) {
                    showSnackBar(context, 'Error: ${state.error}');
                  }
                },
                builder: (context, state) {
                  if (state is ForgotPasswordSubmittingState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    onPressed: () {
                      final email = emailController.text;
                      context
                          .read<ForgotPasswordBloc>()
                          .add(ForgotPasswordSubmitEvent(email));
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Send Reset Link'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
