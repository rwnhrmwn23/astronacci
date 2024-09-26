import 'dart:convert';

import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> user; // Menerima data pengguna dari HomePage

  DetailPage({required this.user}); // Konstruktor untuk menerima data pengguna

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user['name']), // Menampilkan nama pengguna di AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: user['profileImage'] != ""
                  ? MemoryImage(base64Decode(user['profileImage'])) // Konversi Base64 ke Uint8List
                  : null, // Tidak ada gambar jika profileImage adalah string kosong atau null
              child: user['profileImage'] == null || user['profileImage'] == ""
                  ? Icon(Icons.person, size: 50) // Default icon jika tidak ada profile image atau kosong
                  : null,
            ),
            SizedBox(height: 16),
            Text(
              'Name: ${user['name']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Anda bisa menambahkan detail lainnya jika diperlukan
          ],
        ),
      ),
    );
  }
}
