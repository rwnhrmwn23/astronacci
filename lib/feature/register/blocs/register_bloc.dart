import 'package:astronacci/feature/register/blocs/register_state.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'register_event.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {

  RegisterBloc() : super(RegisterInitialState()) {
    // Event untuk mengambil gambar
    on<PickImageEvent>((event, emit) async {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: Colors.blue,
              toolbarWidgetColor: Colors.white,
              activeControlsWidgetColor: Colors.blue,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
            IOSUiSettings(
              title: 'Crop Image',
            ),
          ],
        );

        if (croppedFile != null) {
          emit(ImageCroppedState(croppedFile.path)); // Emit state dengan path gambar
        }
      }
    });

    // Event untuk register user
    on<RegisterUserEvent>((event, emit) async {
      emit(FormSubmittingState()); // Show loading

      try {
        // Buat akun di Firebase Auth
        FirebaseAuth auth = FirebaseAuth.instance;
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        User? user = userCredential.user;
        if (user != null) {
          // Kirim email verifikasi
          await user.sendEmailVerification();

          // Jika ada gambar profil, konversi ke Base64 dan simpan ke Firebase Database
          String? imageBase64 = event.imageBase64;
          String userID = user.uid;
          DatabaseReference databaseRef = FirebaseDatabase.instance.ref('users/$userID');

          // Simpan data pengguna ke Firebase Realtime Database
          await databaseRef.set({
            'name': event.name,
            'profileImage': (imageBase64 != null && imageBase64.isNotEmpty) ? imageBase64 : "", // Tambahkan gambar jika ada
          });

          // Emit sukses setelah registrasi dan email verifikasi dikirim
          emit(FormSubmittedState());
        }
      } catch (error) {
        emit(FormSubmissionFailedState(error.toString())); // Emit jika ada error
      }
    });
  }
}
