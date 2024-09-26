abstract class ForgotPasswordState { }

class ForgotPasswordInitialState extends ForgotPasswordState {}

class ForgotPasswordSubmittingState extends ForgotPasswordState {}

class ForgotPasswordSuccessState extends ForgotPasswordState {}

class ForgotPasswordFailedState extends ForgotPasswordState {
  final String error;

  ForgotPasswordFailedState(this.error);
}
