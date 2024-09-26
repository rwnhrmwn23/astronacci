abstract class HomeEvent {}

class LoadUserDataEvent extends HomeEvent {}

class UpdateProfileEvent extends HomeEvent {
  final String userID;
  final String name;
  final String? profileImage;

  UpdateProfileEvent({
    required this.userID,
    required this.name,
    this.profileImage,
  });
}

