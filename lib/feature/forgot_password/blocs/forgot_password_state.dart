import 'package:equatable/equatable.dart';

abstract class ForgotPasswordState extends Equatable {
  @override
  List<Object> get props => [];
}

class ForgotPasswordInitialState extends ForgotPasswordState {}

class ForgotPasswordSubmittingState extends ForgotPasswordState {}

class ForgotPasswordSuccessState extends ForgotPasswordState {}

class ForgotPasswordFailedState extends ForgotPasswordState {
  final String error;

  ForgotPasswordFailedState(this.error);

  @override
  List<Object> get props => [error];
}
