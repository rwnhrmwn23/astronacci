abstract class RegisterEvent {}

class PickImageEvent extends RegisterEvent {}

class RegisterUserEvent extends RegisterEvent {
  final String name;
  final String email;
  final String password;
  final String? imageBase64;

  RegisterUserEvent(this.name, this.email, this.password, [this.imageBase64]);
}
