abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginSubmittingState extends LoginState {}

class LoginSuccessState extends LoginState {}

class LoginFailedState extends LoginState {
  final String error;

  LoginFailedState({required this.error});
}
