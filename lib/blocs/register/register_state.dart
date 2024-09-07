// edit_profile_state.dart
abstract class RegisterState {}

class RegisterInitialState extends RegisterState {}

// State untuk gambar yang diambil dan di-crop
class ImagePickedState extends RegisterState {
  final String imagePath;
  ImagePickedState(this.imagePath);
}

// State setelah gambar di-crop dan siap diolah
class ImageCroppedState extends RegisterState {
  final String imagePath;
  ImageCroppedState(this.imagePath);
}

// State ketika form sedang dalam proses pengiriman
class FormSubmittingState extends RegisterState {}

// State ketika form sudah berhasil disubmit
class FormSubmittedState extends RegisterState {}

// State jika form submission gagal
class FormSubmissionFailedState extends RegisterState {
  final String error;
  FormSubmissionFailedState(this.error);
}
