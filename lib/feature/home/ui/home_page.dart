import 'dart:convert';
import 'dart:typed_data';

import 'package:astronacci/common/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../detail_profile/detail_page.dart';
import '../../edit_profile/edit_profile_email_page.dart';
import '../../edit_profile/edit_profile_page.dart';
import '../../edit_profile/edit_profile_password_page.dart';
import '../blocs/home_bloc.dart';
import '../blocs/home_event.dart';
import '../blocs/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isUpdate = false;
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();

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
                    const SizedBox(height: 4),
                    Text(
                      "Email : ${user?.email ?? ''}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ); // Access userName here safely
              }
              return const Text('Home');
            },
          ),
          actions: [
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoadedState) {
                  return IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () async {
                      final homeBloc = context.read<HomeBloc>();

                      await showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.person),
                                title: const Text('Ubah Data Diri'),
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
                                leading: const Icon(Icons.email),
                                title: const Text('Ubah Email'),
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
                                title: const Text('Ubah Password'),
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
              icon: const Icon(Icons.logout),
              onPressed: () {
                showLogoutConfirmationDialog(context);
              },
            ),
          ],
        ),
        body: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeErrorState) {
              showSnackBar(context, 'Failed to load users: ${state.message}');
            }
          },
          builder: (context, state) {
            if (state is HomeLoadingState) {
              return const Center(child: CircularProgressIndicator());
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
                      decoration: const InputDecoration(
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
                            const SizedBox(height: 10), // Add spacing above each item
                            ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: profileImage != null
                                    ? MemoryImage(profileImage)
                                    : null,
                                child: profileImage == null
                                    ? const Icon(Icons.person, size: 50)
                                    : null,
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user['name'],
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
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
                        : const Center(child: Text('No users found.')),
                  ),
                ],
              );
            } else if (state is HomeErrorState) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('No data available'));
          },
        ),
      ),
    );
  }
}
