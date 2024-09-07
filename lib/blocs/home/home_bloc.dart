import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<Map<String, dynamic>> usersList = [];

  HomeBloc() : super(HomeInitialState()) {
    on<LoadUserDataEvent>((event, emit) async {
      try {
        emit(HomeLoadingState());

        // Ambil userID dari SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userID = prefs.getString('userID');
        String? userName;
        String? profileImage;

        if (userID != null) {
          // Ambil data pengguna dari Firebase Realtime Database
          DatabaseReference userRef = FirebaseDatabase.instance.ref("users/$userID");
          DatabaseEvent event = await userRef.once();
          final userData = event.snapshot.value as Map?;

          if (userData != null) {
            userName = userData['name'];
            profileImage = userData['profileImage'];
          } else {
            throw Exception('User data not found.');
          }
        }

        // Clear the list before adding new data
        usersList.clear();

        // Ambil semua pengguna kecuali pengguna yang sedang login
        DatabaseReference usersRef = FirebaseDatabase.instance.ref("users");
        DatabaseEvent eventUsers = await usersRef.once();
        final usersData = eventUsers.snapshot.value as Map?;

        if (usersData != null) {
          usersData.forEach((key, userData) {
            if (key != userID) { // Kecualikan pengguna yang sedang login
              final userMap = userData as Map;
              usersList.add({
                'name': userMap['name'],
                'email': userMap['email'],
                'profileImage': userMap['profileImage'],
              });
            }
          });
        } else {
          throw Exception('Users data not found.');
        }

        // Emit state dengan nama pengguna yang login dan daftar pengguna lainnya
        emit(HomeLoadedState(
          userName: userName ?? 'User',
          profileImage: profileImage,
          usersList: usersList,
        ));
      } catch (error) {
        emit(HomeErrorState('Failed to load data: $error'));
      }
    });

    // Tangani pembaruan profil
    on<UpdateProfileEvent>((event, emit) async {
      try {
        // Update data di Firebase Realtime Database
        DatabaseReference userRef = FirebaseDatabase.instance.ref("users/${event.userID}");
        await userRef.update({
          'name': event.name,
          if (event.profileImage != null) 'profileImage': event.profileImage,
        });

        // Emit state dengan data yang diperbarui
        emit(HomeLoadedState(
          userName: event.name,
          profileImage: event.profileImage,
          usersList: usersList, // Tetap gunakan usersList yang sudah ada
        ));

      } catch (error) {
        emit(HomeErrorState('Failed to update profile: $error'));
      }
    });
  }
}
