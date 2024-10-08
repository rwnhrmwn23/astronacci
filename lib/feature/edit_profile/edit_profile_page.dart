import 'dart:convert';
import 'dart:io';
import 'package:astronacci/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/blocs/home_bloc.dart';
import '../home/blocs/home_event.dart';
import '../home/blocs/home_state.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> user;

  EditProfilePage({required this.user});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  File? _imageFile;
  String? _imageBase64;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user['name']);
    _imageBase64 = widget.user['profileImage'];
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  // Fungsi untuk memilih dan memotong gambar
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
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

      // Pastikan file hasil crop tidak null
      if (croppedFile != null) {
        setState(() {
          _imageFile = File(croppedFile.path); // Pastikan menggunakan path file yang di-crop
          _imageBase64 = base64Encode(_imageFile!.readAsBytesSync()); // Konversi gambar yang di-crop ke base64
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeLoadedState) {
            showSnackBar(context, 'Profile updated successfully!');
            Navigator.of(context).pop(true);
          } else if (state is HomeErrorState) {
            showSnackBar(context, 'Failed to update profile: ${state.message}');
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : widget.user['profileImage'] != null && widget.user['profileImage'] != ""
                          ? MemoryImage(base64Decode(widget.user['profileImage']))
                          : null,
                      child: _imageFile == null &&
                          (widget.user['profileImage'] == null ||
                              widget.user['profileImage'] == "")
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      SharedPreferences.getInstance().then((prefs) {
                        String? userID = prefs.getString('userID');
                        if (userID != null) {
                          context.read<HomeBloc>().add(
                            UpdateProfileEvent(
                              userID: userID,
                              name: nameController.text,
                              profileImage: _imageBase64,
                            ),
                          );
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
