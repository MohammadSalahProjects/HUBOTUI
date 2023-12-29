import 'package:flutter/material.dart';
import 'package:hubot/login.dart';
import 'package:hubot/signup_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hubot App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/signup': (context) => SignupScreen(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
