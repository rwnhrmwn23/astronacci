import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginBloc() : super(LoginInitialState()) {
    on<LoginUserEvent>((event, emit) async {
      try {
        emit(LoginSubmittingState());

        // Autentikasi pengguna menggunakan Firebase Authentication
        UserCredential auth = await _auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        // Periksa apakah pengguna berhasil login
        if (auth.user != null) {
          // Cek apakah email sudah diverifikasi
          if (auth.user!.emailVerified) {
            // Jika sudah diverifikasi, lanjutkan ke login sukses
            emit(LoginSuccessState());

            // Simpan userID ke SharedPreferences
            final userID = auth.user?.uid;
            if (userID != null) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('userID', userID);
            }
          } else {
            // Jika email belum diverifikasi, logout dan tampilkan pesan peringatan
            await _auth.signOut();
            emit(LoginFailedState(error: 'Email Anda belum diverifikasi. Periksa email Anda untuk verifikasi.'));
          }
        } else {
          emit(LoginFailedState(error: 'Invalid email or password'));
        }
      } catch (e) {
        emit(LoginFailedState(error: e.toString()));
      }
    });
  }
}
