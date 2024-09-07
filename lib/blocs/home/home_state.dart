abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final String userName;
  final String? profileImage;
  final List<Map<String, dynamic>> usersList;

  HomeLoadedState({
    required this.userName,
    this.profileImage,
    required this.usersList,
  });
}

class HomeErrorState extends HomeState {
  final String message;

  HomeErrorState(this.message);
}
