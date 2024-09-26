abstract class RegisterState {}

class RegisterInitialState extends RegisterState {}

class ImagePickedState extends RegisterState {
  final String imagePath;
  ImagePickedState(this.imagePath);
}

class ImageCroppedState extends RegisterState {
  final String imagePath;
  ImageCroppedState(this.imagePath);
}

class FormSubmittingState extends RegisterState {}

class FormSubmittedState extends RegisterState {}

class FormSubmissionFailedState extends RegisterState {
  final String error;

  FormSubmissionFailedState(this.error);
}
