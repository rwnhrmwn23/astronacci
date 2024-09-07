# Astronacci 

This project is developed using **Flutter** and **Firebase** with **Bloc Pattern** as the state management solution. The app demonstrates user authentication with **Firebase Authentication**, email verification, password reset, and stores user profile data (including name and profile image) in **Firebase Realtime Database**. The project also implements features like image cropping and file management.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Screenshots

1. Application
   
<img width="674" alt="Screenshot 2024-09-07 at 08 07 32" src="https://github.com/user-attachments/assets/6d999602-f025-44af-a116-591247d33dc7">

2. BLoC Pattern Implementation

<img width="674" alt="LoginEvent" src="https://github.com/user-attachments/assets/df354715-aec1-4b96-8001-a27350bf0684">
<img width="674" alt="LoginState" src="https://github.com/user-attachments/assets/94187169-9fd3-4ad5-af7a-bf9142b3fce7">
<img width="674" alt="LoginBloc" src="https://github.com/user-attachments/assets/0870ec9c-770a-4c2b-9540-bd7127c5934a">

3. Firebase Auth and Database Dashboard
<img width="841" alt="Verify Email" src="https://github.com/user-attachments/assets/563dae71-6966-4dee-aefb-df81c00c7c83">
<img width="841" alt="Reset Password" src="https://github.com/user-attachments/assets/94d2203d-b4d3-4d8b-aa79-26973158b52e">
<img width="841" alt="Database Dashboard" src="https://github.com/user-attachments/assets/fdaf47e5-e19e-4037-a65a-53fbb0a34209">
<img width="841" alt="Authentication Dashboard" src="https://github.com/user-attachments/assets/2d50b854-a419-4a39-ae43-827fd00d5947">

## Introduction

This repository contains a simple Flutter app that leverages Firebase for authentication and data management. The app includes the following features:
1. **User Registration** (with email verification)
2. **Login and Logout**
3. **Forgot Password** (Password reset via email)
4. **Edit Profile** (with image cropping)
5. **Store profile data (name and profile image) in Firebase Realtime Database**
6. **List and Search Users functionality in HomePage**

The app demonstrates how to integrate Firebase Authentication for handling email/password sign-ups, email verification, password resets, and secure authentication flows with Bloc Pattern state management.

## Features

### User Registration

- Users can register with their email and password.
- After successful registration, the user is sent a verification email.
- The app prompts users to verify their email before logging in.
- User data such as name and profile image (in Base64 format) is stored in **Firebase Realtime Database**.

### Login and Logout

- Users can log in with their registered email and password.
- If the email is not verified, a message prompts the user to verify it before logging in.
- After login, the user's session is saved in shared preferences.

### Forgot Password

- Users can request a password reset link by providing their registered email.
- Firebase Authentication handles sending the reset password email.

### Edit Profile

- Users can edit their name and profile picture.
- Profile images can be selected from the gallery and cropped before saving.
- The edited profile data is updated in Firebase Realtime Database.

### Show Users Functionality

- Show list user with Image and Name as Preview, and when clicked it will be open the detail information

### Search Functionality

- On the HomePage, users can search through a list of registered users.

## Additional Features

- **Password Hashing**: The app hashes the password before storing or using it for authentication purposes, enhancing security.
- **Logout**: A utility function that allows the user to log out securely, clearing session data from shared preferences.
- **Firebase Realtime Database Storage**: Profile names and images are stored as base64 strings in Firebase Realtime Database, ensuring that all users can access their data securely.
- **Error Handling**: Built-in error handling for scenarios like failed authentication, invalid emails, and failed password resets, using Bloc’s state management for showing error messages.
  
## Firebase Integration

This project uses **Firebase** services to handle authentication, database, and other backend functionalities:
1. **Firebase Authentication** is used for email/password login, registration, email verification, and password reset.
2. **Firebase Realtime Database** stores user profile data (name and image in Base64).

## State Management

The project implements **Bloc Pattern** for state management using `flutter_bloc`. Bloc ensures separation of concerns and improves the maintainability of the app by using events to trigger changes in the UI state.

## Plugins and Dependencies

The app utilizes several Flutter plugins for smooth functionality:

### 1. `flutter_bloc: ^8.0.1`
   - Manages the state of the app by separating business logic and UI using events and states.
  
### 2. `image_picker: ^0.8.5+3`
   - Used to pick images from the device's gallery.

### 3. `image_cropper: ^4.0.1`
   - Allows users to crop selected images before uploading.

### 4. `firebase_database: ^10.4.0`
   - Integrates Firebase Realtime Database for storing user data such as names and profile images.

### 5. `firebase_auth: ^4.16.0`
   - Provides Firebase Authentication functionalities like login, registration, email verification, and password reset.

### 6. `firebase_core: ^2.24.2`
   - Initializes and connects the Flutter app to Firebase.

### 7. `crypto: ^3.0.5`
   - Used for hashing passwords before storing or authenticating.

### 8. `shared_preferences: ^2.3.2`
   - Stores simple key-value pairs on the device, such as user session data (user ID) after login.

### 9. `equatable: ^2.0.3`
   - Ensures simple equality comparisons between states and events in Bloc.

## Conclusion

This project demonstrates the integration of Firebase and Bloc in a Flutter application with features like user authentication, profile management, email verification, and password reset. The project also emphasizes the use of Firebase for managing user data and authentication, along with effective state management using Bloc.

By combining Firebase Authentication with **Firebase Realtime Database**, this app ensures users' profiles are stored and managed securely while maintaining clean code separation using Bloc Pattern for state management.

## Download APK

You can download the APK from the following link: [Download APK](https://github.com/rwnhrmwn23/astronacci/releases/download/release/app-astronacci-release.apk)
