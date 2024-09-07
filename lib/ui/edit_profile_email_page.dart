import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../blocs/home/home_bloc.dart';
import '../blocs/home/home_event.dart';

class EditProfileEmailPage extends StatefulWidget {
  @override
  _EditProfileEmailPageState createState() => _EditProfileEmailPageState();
}

class _EditProfileEmailPageState extends State<EditProfileEmailPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _reauthenticateUser() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Minta password saat ini untuk re-authentication
        AuthCredential credential = EmailAuthProvider.credential(
          email: currentUser.email!,
          password: passwordController.text, // Pastikan ini adalah password yang benar
        );

        // Lakukan re-authentication
        await currentUser.reauthenticateWithCredential(credential);
        return;
      }
    } catch (e) {
      throw Exception('Re-authentication failed: $e');
    }
  }

  Future<void> _updateEmail() async {
    try {
      // Lakukan re-authentication terlebih dahulu
      await _reauthenticateUser();

      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Perbarui email ke email baru
        await currentUser.verifyBeforeUpdateEmail(emailController.text);

        // Kirim verifikasi ke email baru
        await currentUser.sendEmailVerification();

        await currentUser.reload();

        // Emit event ke HomeBloc untuk memperbarui UI
        context.read<HomeBloc>().add(LoadUserDataEvent());

        // Tampilkan dialog sukses
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Email Verification'),
              content: Text(
                  'Periksa email baru Anda untuk memverifikasi perubahan email.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.remove('userID');
                    _auth.currentUser?.reload();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Tampilkan pesan error jika proses gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update email: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubah Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input field untuk email baru
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email Baru',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Input field untuk password saat ini
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password Sekarang',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Tombol untuk submit perubahan email
            ElevatedButton(
              onPressed: _updateEmail,
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
