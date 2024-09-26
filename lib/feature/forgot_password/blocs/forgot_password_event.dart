abstract class ForgotPasswordEvent { }

class ForgotPasswordSubmitEvent extends ForgotPasswordEvent {
  final String email;

  ForgotPasswordSubmitEvent(this.email);
}
