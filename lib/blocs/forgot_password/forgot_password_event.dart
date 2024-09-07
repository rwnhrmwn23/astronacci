import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ForgotPasswordSubmitEvent extends ForgotPasswordEvent {
  final String email;

  ForgotPasswordSubmitEvent(this.email);

  @override
  List<Object> get props => [email];
}
