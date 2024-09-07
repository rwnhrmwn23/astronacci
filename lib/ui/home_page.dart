import 'dart:convert';
import 'dart:typed_data';
import 'package:astronacci/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../blocs/home/home_bloc.dart';
import '../blocs/home/home_event.dart';
import '../blocs/home/home_state.dart';
import 'edit_profile_page.dart';
import 'edit_profile_password_page.dart';
import 'edit_profile_email_page.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isUpdate = false; // To prevent multiple calls for data reload
  String searchQuery = ''; // Untuk menyimpan query pencarian
  TextEditingController searchController = TextEditingController(); // Controller pencarian

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadUserDataEvent()),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoadedState) {
                final user = _auth.currentUser;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome, ${state.userName}'),
                    SizedBox(height: 4),
                    Text(
                      "Email : ${user?.email ?? ''}",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ); // Access userName here safely
              }
              return Text('Home');
            },
          ),
          actions: [
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoadedState) {
                  return IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () async {
                      final homeBloc = context.read<HomeBloc>();

                      await showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(Icons.person),
                                title: Text('Ubah Data Diri'),
                                onTap: () async {
                                  Navigator.pop(context);

                                  final isUpdated =
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider.value(
                                        value: homeBloc,
                                        child: EditProfilePage(
                                          user: {
                                            'name': state.userName,
                                            'profileImage': state.profileImage,
                                          },
                                        ),
                                      ),
                                    ),
                                  );

                                  if (isUpdated == true && mounted) {
                                    setState(() {
                                      isUpdate = true;
                                    });
                                  }
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.email),
                                title: Text('Ubah Email'),
                                onTap: () async {
                                  Navigator.pop(context);
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditProfileEmailPage(),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.lock),
                                title: Text('Ubah Password'),
                                onTap: () async {
                                  Navigator.pop(context);
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditProfilePasswordPage(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                }
                return Container();
              },
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                // Panggil fungsi logout yang ada di utils.dart
                showLogoutConfirmationDialog(context); // Panggil fungsi logout dari utils.dart
              },
            ),
          ],
        ),
        body: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Failed to load users: ${state.message}')),
              );
            }
          },
          builder: (context, state) {
            if (state is HomeLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is HomeLoadedState) {
              // Filter daftar pengguna berdasarkan query pencarian
              final filteredUsers = state.usersList.where((user) {
                final nameLower = user['name'].toLowerCase();
                final searchLower = searchQuery.toLowerCase();
                return nameLower.contains(searchLower);
              }).toList();

              return Column(
                children: [
                  // TextField untuk input pencarian
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value; // Update query pencarian
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search users',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  Expanded(
                    child: filteredUsers.isNotEmpty
                        ? ListView.builder(
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];

                        Uint8List? profileImage;
                        if (user['profileImage'] != "" &&
                            user['profileImage'] != null) {
                          profileImage = base64Decode(user['profileImage']);
                        }

                        return Column(
                          children: [
                            SizedBox(height: 10), // Add spacing above each item
                            ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: profileImage != null
                                    ? MemoryImage(profileImage)
                                    : null,
                                child: profileImage == null
                                    ? Icon(Icons.person, size: 50)
                                    : null,
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user['name'],
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => DetailPage(user: user),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    )
                        : Center(child: Text('No users found.')),
                  ),
                ],
              );
            } else if (state is HomeErrorState) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text('No data available'));
          },
        ),
      ),
    );
  }
}
