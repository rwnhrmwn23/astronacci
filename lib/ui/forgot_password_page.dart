import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/forgot_password/forgot_password_bloc.dart';
import '../blocs/forgot_password/forgot_password_event.dart';
import '../blocs/forgot_password/forgot_password_state.dart';
import 'login_page.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Forgot Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
                listener: (context, state) {
                  if (state is ForgotPasswordSuccessState) {
                    // Tampilkan dialog setelah tautan reset password berhasil dikirim
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Tautan Reset Terkirim'),
                          content: Text(
                            'Tautan reset kata sandi telah dikirim ke ${emailController.text}. '
                                'Periksa email Anda dan ikuti instruksi untuk mereset kata sandi.',
                          ),
                          actions: [
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Tutup dialog
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(), // Arahkan ke halaman login
                                  ),
                                );                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else if (state is ForgotPasswordFailedState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${state.error}')),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ForgotPasswordSubmittingState) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    onPressed: () {
                      final email = emailController.text;
                      context.read<ForgotPasswordBloc>().add(ForgotPasswordSubmitEvent(email));
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text('Send Reset Link'),
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
