import 'package:astronacci/ui/home_page.dart';
import 'package:astronacci/ui/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/home/home_bloc.dart';
import 'ui/forgot_password_page.dart';
import 'ui/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Cek apakah user ID sudah ada
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userID = prefs.getString('userID');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(),
        ),
      ],
      child: MyApp(userID: userID),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? userID;

  MyApp({this.userID});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: userID == null ? '/' : '/home', // Tentukan route awal berdasarkan userID
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => BlocProvider.value(
          value: context.read<HomeBloc>(), // Pastikan HomeBloc diteruskan
          child: HomePage(),
        ),
        '/register': (context) => RegisterPage(),
        '/forgot-password': (context) => ForgotPasswordPage(),
      },
    );
  }
}
