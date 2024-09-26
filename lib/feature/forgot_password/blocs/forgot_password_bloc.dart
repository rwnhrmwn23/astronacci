import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ForgotPasswordBloc() : super(ForgotPasswordInitialState()) {
    on<ForgotPasswordSubmitEvent>((event, emit) async {
      emit(ForgotPasswordSubmittingState());
      try {
        // Kirim email reset password ke Firebase Auth
        await _auth.sendPasswordResetEmail(email: event.email);
        emit(ForgotPasswordSuccessState());
      } catch (e) {
        emit(ForgotPasswordFailedState(e.toString()));
      }
    });
  }
}
