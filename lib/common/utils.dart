import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mengonversi gambar menjadi Base64 string.
/// Mengembalikan string kosong jika file tidak valid atau null.
String convertImageToBase64(File? imageFile) {
  if (imageFile == null || !imageFile.existsSync()) {
    return '';
  }

  try {
    final bytes = imageFile.readAsBytesSync();
    return base64Encode(bytes);
  } catch (e) {
    return '';
  }
}

/// Meng-hash password menggunakan SHA-256.
/// Mengembalikan string hash.
String hashPassword(String password) {
  final bytes = utf8.encode(password); // Konversi password ke bytes
  final digest = sha256.convert(bytes); // Hash password menggunakan SHA-256
  return digest.toString(); // Kembalikan hasil hash dalam format string
}

/// Function Logout dengan Konfirmasi dialog yang akan  :
/// 1. Menghapus data lokal dari sharedPreference (userID)
/// 2. Reload currentUser dari Firebase Auth
/// 3. Kembali ke login page
void showLogoutConfirmationDialog(BuildContext context) {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirm Logout"),
        content: Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("Logout"),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('userID');
              _auth.currentUser?.reload();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
        ],
      );
    },
  );
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
