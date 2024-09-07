// edit_profile_event.dart
abstract class RegisterEvent {}

class PickImageEvent extends RegisterEvent {}

// Event untuk register user
class RegisterUserEvent extends RegisterEvent {
  final String name;
  final String email;
  final String password;
  final String? imageBase64; // Base64 gambar (optional jika tidak ada gambar)

  RegisterUserEvent(this.name, this.email, this.password, [this.imageBase64]);
}
